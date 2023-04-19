//
//  MapViewDisplay.swift
//  Voice Note
//
//  Created by Tai Nguyen on 4.4.2023.
//

import SwiftUI
import CoreLocation

struct MapScreen: View {
    @EnvironmentObject var mapViewModel: MapViewModel
    @State var clickOnPin: Bool = false
    @State var locationManager = CLLocationManager()
    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)

    var body: some View {
        ZStack{
            MapView(clickOnPin: $clickOnPin)
                .ignoresSafeArea(.all, edges: .all)
                .sheet(isPresented: $clickOnPin) {
                    DetailView(voiceNote: VoiceNote(
                        noteId: UUID(),
                        noteTitle: "Note - 1",
                        noteText: "This place is good to come back in the summer. There are a lot of mushrooms and berries to pick up. Take good camera lens with me also for a good lanscape shot",
                        noteDuration: TimeDuration(size: 3765),
                        noteCreatedAt: Date.init(),
                        noteTakenNear: "Ruoholahti",
                        voiceNoteLocation: CLLocation(latitude: 24.33, longitude: 33.56)
                    ))
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            
            VStack {
                
                SearchOptionsBar(searchQuery: $mapViewModel.searchText)
                if !mapViewModel.places.isEmpty && mapViewModel.searchText != "" {
                    
                    ScrollView {
                        VStack {
                            ForEach(mapViewModel.places) {place in
                                Text(place.place.name ?? "")
                                    .foregroundColor(Color(buttonColor))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .onTapGesture{
                                        mapViewModel.selectPlace(place: place)
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
                    
                    Button(action: mapViewModel.focusLocation, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                            .foregroundColor(Color(buttonColor))
                    })
                    
                    Button(action: mapViewModel.updateMapType, label: {
                        Image(systemName: mapViewModel.mapType ==
                            .standard ? "network" : "map")
                        .font(.title2)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                        .foregroundColor(Color(buttonColor))
                    })
                    Button(action: mapViewModel.getDirection, label: {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
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
            locationManager.delegate = mapViewModel
            locationManager.requestWhenInUseAuthorization()
        })

        //Permission Denied Alert
        .alert(isPresented: $mapViewModel.permissionDenied, content: {
            
            Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission in App Settings"), dismissButton: .default(Text("Go to Settings"), action: {
                
                //Redirecting user to setting
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
        )})
        .onChange(of: mapViewModel.searchText, perform: {value in
            //Searching places
            
            
            //Delay to avoid continous search
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapViewModel.searchText {
                    //Search...
                    self.mapViewModel.searchQuery()
                }
            }
        })
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen().environmentObject(MapViewModel())
    }
}
