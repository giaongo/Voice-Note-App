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

    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
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
                
                let viewDetailButton = UIButton()
                viewDetailButton.frame.size.width = 44
                viewDetailButton.frame.size.height = 44
                viewDetailButton.setTitleColor(.black, for: .normal)
                viewDetailButton.setTitle("Button Clicked", for: .normal)
                viewDetailButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                pinAnnotation.detailCalloutAccessoryView = viewDetailButton
                return pinAnnotation
            }
        }
        
        @objc func buttonAction() -> Void {

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
        MapView().environmentObject(MapViewModel())
    }
}
