import SwiftUI
import MapKit
import CoreLocation
import CoreData

/**
   A ViewModel that contains properties and functionalities, associated with fetching location, searching for places as well as direction routing.
 */
class MapViewModel: NSObject, ObservableObject {

    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020), latitudinalMeters: 2000, longitudinalMeters: 2000)
    @Published var shouldRegionUpdate = true
    //SearchText...
    @Published var searchText = ""
    // Searched places
    @Published var places: [Place] = []
    // Markers that will show on map
    @Published var mapMarkers: [MapMarker] = []
    // Location service singleton
    private var locationService = LocationService.sharedLocationService

    @Published var searchFilter: SearchFilter = SearchFilter()

    override init() {
        super.init()
        populateLocation()
    }

    //Search Places...
    func searchQuery() {
        if searchFilter.defaultValue == SearchFilterItem.BY_PLACES {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchText
            //Fetch...
            MKLocalSearch(request: request).start { [self] (response, _) in
                guard let result = response else {
                    return
                }
                places = result.mapItems.compactMap {
                    Place(place: $0.placemark, tags: $0.placemark.name ?? "")
                }
            }
        }
        if searchFilter.defaultValue == SearchFilterItem.BY_VOICE_NOTE {
            places = mapMarkers
                    .filter{ mapMarker in mapMarker.taggedText.lowercased().contains(searchText.lowercased()) }
                    .map{ mapMarker -> Place in
                        Place(place: MKPlacemark(coordinate: mapMarker.coordinate), tags: mapMarker.taggedText)
                    }
        }
    }

    func removeSearchTypeMarkers(from markers: [MapMarker]) {
        let newMapMarkers = markers.filter {
            $0.type == AnnotationType.VOICE_NOTE
        }
        mapMarkers = newMapMarkers
    }

    //Pick search result
    func selectPlace(place: Place) {
        searchText = ""
        places.removeAll()
        mapMarkers.append(transform(from: place.place))
        reCenterRegion(at: place.place.coordinate)
    }

    func deleteSelectedVoiceNoteFromMap(at location: Double) {

    }

    func populateLocation() {
        let managedContext = CoreDataService.localStorage.getManageObjectContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "VoiceNote")
        do {
            let voiceNotes = try managedContext.fetch(fetchRequest) as? [VoiceNote] ?? []
            mapMarkers = voiceNotes.compactMap {
                        $0
                    }
                    .map { voiceNote -> MapMarker? in
                        transform(from: voiceNote)
                    }
                    .compactMap {
                        $0
                    }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }

    func removeSearchItemsFromMap() {
        places.removeAll()
        removeSearchTypeMarkers(from: mapMarkers)
    }

    private func transform(from voiceNote: VoiceNote) -> MapMarker? {
        if let id = voiceNote.id, let location = voiceNote.location, let text = voiceNote.text {
            return createMapMarker(id: id, text: text, type: AnnotationType.VOICE_NOTE, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        return nil
    }

    private func transform(from placeMark: MKPlacemark) -> MapMarker {
        createMapMarker(text: "", type: AnnotationType.SEARCH_RESULT, coordinate: placeMark.coordinate)
    }

    private func createMapMarker(id: UUID = UUID(), text taggedText: String, type: AnnotationType, coordinate: CLLocationCoordinate2D) -> MapMarker {
        MapMarker(id: id, taggedText: taggedText, type: type, coordinate: coordinate)
    }

    func reCenterRegionToUserLocation() {
        reCenterRegion(at: locationService.currentLocation.coordinate)
    }

    func reCenterRegion(at coordinate: CLLocationCoordinate2D) {
        region.center = coordinate
    }

    func getCurrentLocation() -> CLLocationCoordinate2D {
        locationService.currentLocation.coordinate
    }

    /**
        Direction for users current location
     - Parameters:
       - destination: CLLocationCoordinate2D that represent Destination location
       - directionMode: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsDirectionsModeTransit
       - destinationName: Sting name that will represent Destination in Apple Map application*/
    func openDirectionInAppleMapFromCurrentLocation(to destination: CLLocationCoordinate2D, directionMode: String, destinationName: String = "Your Destination") {
        openDirectionInAppleMap(from: getCurrentLocation(), to: destination, directionMode: directionMode, destinationName: destinationName)
    }

    func openDirectionInAppleMap(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, directionMode: String, destinationName: String = "Your Destination") {

        let sourceMapItem = MKMapItem(placemark: MKPlacemark(coordinate: source))
        sourceMapItem.name = "Current Location"

        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        destinationMapItem.name = destinationName

        MKMapItem.openMaps(with: [sourceMapItem , destinationMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey : directionMode])
    }
}