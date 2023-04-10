//
//  Voice_NoteApp.swift
//  Voice Note
//
//  Created by iosdev on 22.3.2023.
//

import SwiftUI


@main
struct Voice_NoteApp: App {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @StateObject var voiceNoteViewModel = VoiceNoteViewModel()
    @StateObject var mapViewModel = MapViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }.environmentObject(speechRecognizer).environmentObject(voiceNoteViewModel).environmentObject(MapViewModel())
        }
    }
}
