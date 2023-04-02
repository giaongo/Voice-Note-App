//
//  MapView.swift
//  Voice Note
//
//  Created by iosdev on 2.4.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 60.192, longitude: 24.945), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $region, showsUserLocation: true)
                .ignoresSafeArea()
                .onAppear{
                    viewModel.checkIfLocationServicesIsEnabled()
                }
            HStack {
                Spacer()
                if let location = viewModel.location {
                    Text("Your location:\(location.latitude), \(location.longitude)")
                }
                Button("-") {
                    region.span.latitudeDelta /= 0.6
                    region.span.longitudeDelta /= 0.6
                    viewModel.requestLocation()
                }
                .padding()
                .background(.black)
                .foregroundColor(.white)
                
                // Map Zoom in button
                Button("+") {
                    region.span.latitudeDelta *= 0.6
                    region.span.longitudeDelta *= 0.6
                }
                .padding()
                .background(.black)
                .foregroundColor(.white)
            }
        }
    }
}
    
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
    
final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
    
    private var locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    
    func requestLocation(){
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
        
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
                break
            @unknown default:
                break
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
}


