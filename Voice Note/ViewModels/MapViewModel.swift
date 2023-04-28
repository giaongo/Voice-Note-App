import SwiftUI
import MapKit
import CoreLocation
import CoreData

/**
   A ViewModel that contains properties and functionalities, associated with fetching location, searching for places as well as direction routing.
 */
class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
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

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Request a user’s location once
        //locationManager.requestLocation()

        // Use requestAlwaysAuthorization if you need location
        // updates even when your app is running in the background
        //locationManager.requestAlwaysAuthorization()

        // Use requestWhenInUseAuthorization if you only need
        // location updates when the user is using your app
        locationManager.requestWhenInUseAuthorization()

        locationManager.startUpdatingLocation()

        populateLocation()
    }

    deinit {
        locationManager.stopUpdatingLocation()
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
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        lastLocation = location
        if shouldRegionUpdate {
            region.center = location.coordinate
        }

        /*
        // Altitude
        let altitude = lastLocation.altitude

        // Speed
        let speed = lastLocation.speed

        // Course, degrees relative to due north
        let source = lastLocation.course

        // Distance between two CLLocation
        // Given another CLLocation, otherLocation
        let distanceDelta = lastLocation.distance(from: otherLocation)
         */
    }

    func deleteSelectedVoiceNoteFromMap(at location: Double) {

    }

    private func populateLocation() {
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
}