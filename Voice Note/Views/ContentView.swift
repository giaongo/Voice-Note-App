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
    var body: some View {
        VStack(spacing:0) {
            Spacer()
            BottomBarView(toast: $toast)
        }
        .background(
            Home()
        )
        .toastView(toast: $toast)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView().environmentObject(VoiceNoteViewModel()).environmentObject(SpeechRecognizer())
        }
    }
}
