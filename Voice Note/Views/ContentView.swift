//
//  ContentView.swift
//  Voice Note
//
//  Created by iosdev on 22.3.2023.
//

import SwiftUI

struct ContentView: View {
    @State var increaseHeight: Bool = false
    @State var toast:ToastView? = nil
    @State var showSheet: Bool = false
    @State var tagSelect = "house"
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection:$tagSelect) {
                MapScreen().tag("house")
                Color.purple.tag("mic.fill")
                RecordingListView().tag("list.dash")
            }
            BottomBarView(toast: $toast,showSheet: $showSheet, tagSelect: $tagSelect)
        }
        .toastView(toast: $toast)
        .ignoresSafeArea()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView().environmentObject(VoiceNoteViewModel()).environmentObject(SpeechRecognizer())
        }
    }
}
