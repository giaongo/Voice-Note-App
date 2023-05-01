import SwiftUI
import CoreLocation
import MapKit

struct MapScreen: View {

    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)

    @EnvironmentObject var mapViewModel: MapViewModel
    @State var clickOnPin: Bool = false
    @State private var isShowingSheet = false
    @ObservedObject var  locationService = LocationService.sharedLocationService

    var body: some View {
        if locationService.isLocationAuthorized {
        ZStack {
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

                //Custom Search bar on map
                 SearchOptionsBar(searchQuery: $mapViewModel.searchText, onSearchQuery: {
                     let delay = 0.3
                     DispatchQueue.main.asyncAfter(deadline: .now() + delay) {mapViewModel.searchQuery()}
                 }, onCancelSearch: {
                     mapViewModel.removeSearchItemsFromMap()
                 }, searchFilter: $mapViewModel.searchFilter.defaultValue)

                // Search suggestions list
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

                // Side buttons on map
                MapButtons()
            }
        }.task{
                    mapViewModel.reCenterRegionToUserLocation()

                }
        } else {
            Text("VoiceNote is not Authorized to access your location")
        }
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
    }
}
