//
//  Home.swift
//  Voice Note
//
//  Created by iosdev on 4.4.2023.
//

import SwiftUI
import CoreLocation

struct Home: View {
    @StateObject var mapData = MapViewModel()
    //Location Manager...
    @State var locationManager = CLLocationManager()
    var body: some View {
        ZStack{
            
            MapView()
                //using it as environment object so that it can be used ints subViews
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $mapData.searchText)
                    
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.white)
                .padding()
                
                Spacer()
                
                VStack {
                    
                    Button(action: mapData.focusLocation, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .clipShape(Circle())
                    })
                    
                    Button(action: mapData.updateMapType, label: {
                        Image(systemName: mapData.mapType ==
                            .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .clipShape(Circle())
                    })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .onAppear(perform: {
            
            //Setting Delegate
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        })
        //Permission Denied Alert
        .alert(isPresented: $mapData.permissionDenied, content: {
            
            Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission in App Settings"), dismissButton: .default(Text("Go to Settings"), action: {
                
                //Redirecting user to setting
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
        )})
        .onChange(of: mapData.searchText, perform: {value in
            //Searching places
            
            
            //Delay to avoid continous search
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapData.searchText {
                    //Search...
                    self.mapData.searchQuery()
                }
            }
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
