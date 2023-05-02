// 
// Created by Anwar Ulhaq on 2.5.2023.
// Coded by Daria, Giao and Tai
// 

import Foundation
import SwiftUI

struct SearchSuggestionList: View {

    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)

    @EnvironmentObject var mapViewModel: MapViewModel

    var body: some View {
        ScrollView {
            if !mapViewModel.places.isEmpty && mapViewModel.searchText != "" {
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
                }.padding(.top)
            }
        }.background(Color(.systemGray6))
    }
}
