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
    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)

    var body: some View {
        ZStack{
            
            MapView()
                //using it as environment object so that it can be used ints subViews
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                
                SearchOptionsBar(searchQuery: $mapData.searchText)
                if !mapData.places.isEmpty && mapData.searchText != "" {
                    
                    ScrollView {
                        VStack {
                            ForEach(mapData.places) {place in
                                Text(place.place.name ?? "")
                                    .foregroundColor(Color(buttonColor))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .onTapGesture{
                                        mapData.selectPlace(place: place)
                                    }
                                
                                Divider()
                            }
                        }
                        .padding(.top)
                    }
                    .background(Color(.systemGray6))
                }
                
                Spacer()
                
                VStack {
                    
                    Button(action: mapData.focusLocation, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                            .foregroundColor(Color(buttonColor))
                    })
                    
                    Button(action: mapData.updateMapType, label: {
                        Image(systemName: mapData.mapType ==
                            .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                            .foregroundColor(Color(buttonColor))
                    })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 100)
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
