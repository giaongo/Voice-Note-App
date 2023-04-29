import SwiftUI
import CoreLocation
import MapKit

struct MapScreen: View {

    @StateObject var mapViewModel = MapViewModel()

    @State var clickOnPin: Bool = false
    @State private var isShowingSheet = false

    // TODO or or NOT-TODO is this be a Singleton

    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)

    @State var centerMap = true
    @State var locationIndicator = true

    var body: some View {
        ZStack {
             //FIXME: Find a way to handle region
            //Map(coordinateRegion: .constant(region) , showsUserLocation: true, annotationItems: mapViewModel.mapMarkers) { marker in
            Map(coordinateRegion: .constant(mapViewModel.region) , showsUserLocation: true, annotationItems: mapViewModel.mapMarkers) { marker in
                MapAnnotation(coordinate: marker.coordinate) {

                    if marker.type == AnnotationType.SEARCH_RESULT {

                        Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 36))
                                .padding(10)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                                .foregroundColor(Color(buttonColor))
                                .onTapGesture {
                                    mapViewModel.reCenterRegion(at: marker.coordinate)
                                }
                    }
                    if marker.type == AnnotationType.VOICE_NOTE {
                        Image(systemName: "waveform.circle")
                                .font(.system(size: 36))
                                .padding(10)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                                .foregroundColor(Color(buttonColor))
                                .onTapGesture {
                                    isShowingSheet.toggle()
                                    mapViewModel.reCenterRegion(at: marker.coordinate)
                                }.sheet(isPresented: $isShowingSheet, onDismiss: mapViewModel.populateLocation) {
                                    if let id = marker.id {
                                        DetailView(voiceNoteUUID: id)
                                    }
                                }
                    }
                }
            }

            VStack {
                 SearchOptionsBar(searchQuery: $mapViewModel.searchText, onSearchQuery: {
                     let delay = 0.3
                     DispatchQueue.main.asyncAfter(deadline: .now() + delay) {mapViewModel.searchQuery()}
                 }, onCancelSearch: {
                     mapViewModel.removeSearchItemsFromMap()
                 }, searchFilter: $mapViewModel.searchFilter.defaultValue)
                if !mapViewModel.places.isEmpty && mapViewModel.searchText != "" {
                    ScrollView {
                        VStack {
                            ForEach(mapViewModel.places) {place in
                                Text(place.tags)
                                    .foregroundColor(Color(buttonColor))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .onTapGesture{
                                        mapViewModel.selectPlace(place: place)
                                    }.textCase(.lowercase)
                                
                                Divider()
                            }
                        }
                        .padding(.top)
                    }
                    .background(Color(.systemGray6))
                }
                
                Spacer()
                
                VStack {
                    Button(action: {
                        centerMap.toggle()
                        locationIndicator.toggle()
                    }, label: {
                        Image(systemName: locationIndicator ? "location.fill" : "location.slash.fill")
                            .font(.system(size: 36))
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                            .foregroundColor(Color(buttonColor))
                    })
                    // TODO fix change map type later
                    Button(action: { (() -> Void).self  }, label: {
                        Image(systemName: /*mapViewModel.mapType ==
                            .standard ? "network" :*/ "map")
                        .font(.system(size: 36))
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                        .foregroundColor(Color(buttonColor))
                    })

                    // TODO fix it later
                    Button(action: { (() -> Void).self  }, label: {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                            .font(.system(size: 36))
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                            .foregroundColor(Color(buttonColor))
                    })
                    // TODO Center map
                    Button(action: {
                         mapViewModel.reCenterRegionToUserLocation()
                    }, label: {
                        Image(systemName: "smallcircle.filled.circle")
                                .font(.system(size: 36))
                                .padding(10)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                                .foregroundColor(Color(buttonColor))
                    })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .padding(.bottom, 100)
            }
        }
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
    }
}
