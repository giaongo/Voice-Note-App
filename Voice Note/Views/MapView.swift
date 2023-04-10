//
//  MapView.swift
//  Voice Note
//
//  Created by Tai Nguyen on 2.4.2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let pinColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)

    @EnvironmentObject var mapData: MapViewModel

    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = mapData.mapView

        view.showsUserLocation = true
        view.delegate = context.coordinator

        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        return
    }


    class Coordinator: NSObject, MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            //Custom pins
            //Excludes user-pin
            if annotation.isKind(of: MKUserLocation.self){return nil}
            else{
                // TODO: change the pin image and design
                let pinAnnotation = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
                pinAnnotation.glyphImage = UIImage(systemName: "mappin.and.ellipse")
                pinAnnotation.markerTintColor = .magenta
                pinAnnotation.animatesWhenAdded = true
                pinAnnotation.canShowCallout = true
                
                return pinAnnotation
            }
        }

    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environmentObject(MapViewModel())
    }
}
