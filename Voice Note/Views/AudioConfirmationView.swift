//
//  AudioConfirmationView.swift
//  Voice Note
//
//  Created by iosdev on 5.4.2023.
//

import SwiftUI

struct AudioConfirmationView: View {
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    var body: some View {
        VStack{
            Text("\(speechRecognizer.transcriptionText)").font(.headline).fontWeight(.bold).padding(.horizontal,10)
            recordingCardView()
        }
    }
}

struct recordingCardView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    let borderColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    var body: some View {
        HStack() {
            if voiceNoteViewModel.soundSamples.count != 0 {
                ForEach(voiceNoteViewModel.soundSamples, id: \.self) { sampleValue in
                    WaveView(value: voiceNoteViewModel.normalizeSoundLevel(level: sampleValue,barHeight: CGFloat(50)))

                }
            }
            Button {
                if let newestRecordUrl = voiceNoteViewModel.fileUrlList.last {
                    voiceNoteViewModel.startPlaying(recordingUrl: newestRecordUrl)
                }

            } label: {
                Image(systemName: "play.fill")
            }

        }
        .frame(alignment: .leading)
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color(borderColor), lineWidth: 2))
    }
}

struct AudioConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        AudioConfirmationView().environmentObject(SpeechRecognizer()).environmentObject(VoiceNoteViewModel(numberOfSample: samples))
    }
}
