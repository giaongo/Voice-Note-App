//
//  MapViewModel.swift
//  Voice Note
//
//  Created by Tai Nguyen on 2.4.2023.
//

import MapKit
import Foundation


enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 60.192, longitude: 24.945)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation,
                                               span: MapDetails.defaultSpan)
    
    private var locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    
        func checkIfLocationServicesIsEnabled() {
            if CLLocationManager.locationServicesEnabled(){
                locationManager = CLLocationManager()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
            } else {
                //let them know they need to enable
            }
        }
        
        private func checkLocationAuthorization() {
            
            switch locationManager.authorizationStatus {
                
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .restricted:
                    print("Your location is restricted likely due to parental controls")
                case .denied:
                    print("Your location is restricted likely due to parental controls")
                case .authorizedAlways, .authorizedWhenInUse:
                region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                            span: MapDetails.defaultSpan)
                @unknown default:
                    break
                }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
}
