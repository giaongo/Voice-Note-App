//
//  ContentView.swift
//  Voice Note
//
//  Created by iosdev on 22.3.2023.
//

import SwiftUI

struct ContentView: View {
    @State var showSheet:Bool = false
    @State var increaseHeight: Bool = false
    var body: some View {
        VStack(spacing:0) {
            Spacer()
            if showSheet {
                SlidingModalView()
            }
            BottomBarView(showSheet: $showSheet)
        }
        .background(
            Home()
        )
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView().environmentObject(VoiceNoteViewModel(numberOfSample: samples)).environmentObject(SpeechRecognizer())
        }
    }
}
