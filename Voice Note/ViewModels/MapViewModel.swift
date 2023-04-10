//
//  MapViewModel.swift
//  Voice Note
//
//  Created by Tai Nguyen on 2.4.2023.
//

import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
    @Published var mapView = MKMapView()
    
    //Region
    @Published var region : MKCoordinateRegion!
    //Based on Location it will set up..
    
    //Alert
    @Published var permissionDenied = false
    
    //Map type...
    @Published var mapType: MKMapType = .standard
    
    //SearchText...
    @Published var searchText = ""
    
    // Searched places
    @Published var places: [Place] = []
    
    
    //Update Map Type...
    func updateMapType() {
        if mapType == .standard {
            mapType = .hybrid
            mapView.mapType = mapType
        } else {
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
    //Focus Location...
    func focusLocation() {
        guard let _ = region else {return}
        
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    //Search Places...
    func searchQuery() {
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        //Fetch...
        MKLocalSearch(request: request).start { (response, _) in

            guard let result = response else{return}
            
            self.places = result.mapItems.compactMap {(item) -> Place? in
                return Place(place: item.placemark)
            }
        }
    }
    
    //Pick search result
    func selectPlace(place: Place) {
        //Show pin on map
        searchText = ""
        
        guard let coordinate = place.place.location?.coordinate else{return}
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.place.name ?? "Name unknown"
        
        //Remove old annotations
        //TODO: don´t delete annotations made by notes
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(pointAnnotation)
        
        //Move map to searched place
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
 
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //Check with permission
        switch manager.authorizationStatus {
            
        case .notDetermined:
            //Requesting
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            //If Permission given
            manager.requestLocation()
        case .denied:
            //Alert
            permissionDenied.toggle()
        case .restricted,.authorizedAlways:
            print("Permission is restricted")
        @unknown default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    //Getting user region
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        
        //Updating Map...
        self.mapView.setRegion(self.region, animated: true)
        
        //Smooth Animations...
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}
