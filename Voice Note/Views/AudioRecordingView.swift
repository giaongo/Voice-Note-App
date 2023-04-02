//
//  AudioRecordingView.swift
//  Voice Note
//
//  Created by Giao Ngo on 31.3.2023.
//

import SwiftUI

struct AudioRecordingView: View {
    @State var message:String = ""
    @ObservedObject var speechRecognizer = SpeechRecognizer()
    @ObservedObject var voiceNoteViewModel = VoiceNoteViewModel()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack() {
                Text("Recording scene")
                Spacer()
                Text("Transcription message")
                Text("\(message)")
                Spacer()
                BottomBarView(message: $message)
            }
        }
    }
    
}


struct AudioRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordingView()
    }
}
