// 
// Created by Anwar Ulhaq on 28.4.2023.
// 
// 

import Foundation
import CoreLocation
import Combine
import MapKit

class LocationService: NSObject, CLLocationManagerDelegate {

    static var sharedLocationService = LocationService()
    private let locationManager = CLLocationManager()
    var locationStatus: CLAuthorizationStatus?
    var currentLocation: CLLocation?

    private var isLocationUpdate = true

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

    private override init() {
        print(#function, "Location service initiated")
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
    }

    deinit {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        currentLocation = location

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

    func enableLocationUpdates() {
        locationManager.startUpdatingLocation()
    }

    func disableLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }

    func getCurrentLocation() {
        currentLocation
    }
}