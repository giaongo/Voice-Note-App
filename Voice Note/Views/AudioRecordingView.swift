//
//  AudioRecordingView.swift
//  Voice Note
//
//  Created by iosdev on 31.3.2023.
//

import SwiftUI

struct AudioRecordingView: View {
    @State var message:String = ""
    @State var isRecoding: Bool = false
    @StateObject var speechRecognizer = SpeechRecognizer()
    
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
                Button {
                    clickAudioButton()
                } label: {
                    Image(systemName: "\(isRecoding ? "mic" : "mic.fill")")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                .padding(.all,20)
                .background(
                    Circle()
                        .fill(.orange)
                )
            }
        }
    }
    
    private func clickAudioButton() {
        isRecoding = !isRecoding
        if isRecoding {
            message = ""
            speechRecognizer.reset()
            speechRecognizer.transcribe()
        } else {
            speechRecognizer.stopTranscribing()
            message = speechRecognizer.transcriptionText
        }
    }
    
}

struct AudioRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordingView()
    }
}
