//
//  MapView.swift
//  Voice Note
//
//  Created by Tai Nguyen on 2.4.2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        return
    }
    
    
    @EnvironmentObject var mapData: MapViewModel
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = mapData.mapView
        
        view.showsUserLocation = true
        view.delegate = context.coordinator
        
        return view
    }
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
    }
    
}
    
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
