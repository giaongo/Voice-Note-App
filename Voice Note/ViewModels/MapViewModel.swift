import SwiftUI
import MapKit
import CoreLocation
import CoreData

/**
   A ViewModel that contains properties and functionalities, associated with fetching location, searching for places as well as direction routing.
 */
class MapViewModel: NSObject, ObservableObject {

    @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020),
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
    )
    @Published var shouldRegionUpdate = true
    //SearchText...
    @Published var searchText = ""
    // Searched places
    @Published var places: [Place] = []
    // Markers that will show on map
    @Published var mapMarkers: [MapMarker] = []
    // Location service singleton
    private var locationService = LocationService.sharedLocationService

    override init() {
        super.init()
        populateLocation()
    }

    //Search Places...
    func searchQuery() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        //Fetch...
        MKLocalSearch(request: request).start { [self] (response, _) in
            guard let result = response else{return}
            places = result.mapItems.compactMap{Place(place: $0.placemark)}
        }
    }

    func removeSearchTypeMarkers(from markers: [MapMarker]) {
        let newMapMarkers = markers.filter{$0.type == AnnotationType.VOICE_NOTE}
        mapMarkers = newMapMarkers
    }
    
    //Pick search result
    func selectPlace(place: Place) {
        searchText = ""
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
            mapMarkers = voiceNotes
                    .compactMap{$0}
                    .map{ voiceNote -> MapMarker? in transform(from: voiceNote) }
                    .compactMap{$0}
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }

    func removeSearchItemsFromMap() {
        places.removeAll()
        removeSearchTypeMarkers(from: mapMarkers)
    }

    private func transform(from voiceNote: VoiceNote) -> MapMarker? {
        if let id = voiceNote.id, let location = voiceNote.location {
            return createMapMarker(id: id, type: AnnotationType.VOICE_NOTE, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        return nil
    }

    private func transform(from placeMark: MKPlacemark) -> MapMarker {
        createMapMarker(type: AnnotationType.SEARCH_RESULT, coordinate: placeMark.coordinate)
    }

    private func createMapMarker(id: UUID = UUID(), type: AnnotationType, coordinate: CLLocationCoordinate2D) -> MapMarker {
        MapMarker(id: id, type: type, coordinate: coordinate)
    }

    func reCenterRegionToUserLocation() {
        reCenterRegion(at: locationService.currentLocation.coordinate)
    }

    func reCenterRegion(at coordinate: CLLocationCoordinate2D) {
        region.center = coordinate
    }

    func getCurrentLocation () -> CLLocationCoordinate2D{
        locationService.currentLocation.coordinate
    }
}