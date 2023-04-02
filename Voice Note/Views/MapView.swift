//
//  MapView.swift
//  Voice Note
//
//  Created by Tai Nguyen on 2.4.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
   
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                .ignoresSafeArea()
                .onAppear{
                    viewModel.checkIfLocationServicesIsEnabled()
                }
        }
    }
}
    
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
    


