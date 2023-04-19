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
    @EnvironmentObject var mapViewModel: MapViewModel
    @Binding var clickOnPin: Bool
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = mapViewModel.mapView
        view.showsUserLocation = true
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        return
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
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
                
                // Add view detail button on the pin
                let viewDetailButton = UIButton()
                viewDetailButton.frame.size.width = 40
                viewDetailButton.frame.size.height = 44
                viewDetailButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
                viewDetailButton.addTarget(self, action: #selector(pinClickAction), for: .touchUpInside)
                pinAnnotation.leftCalloutAccessoryView = viewDetailButton
                return pinAnnotation
            }
        }
        
        @objc func pinClickAction() {
            parent.clickOnPin = true
        }
        
        //Create overlay route
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(clickOnPin: .constant(true)).environmentObject(MapViewModel())
    }
}
