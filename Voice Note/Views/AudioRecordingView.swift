//
//  AudioRecordingView.swift
//  Voice Note
//
//  Created by Giao Ngo on 31.3.2023.
//

import SwiftUI

struct AudioRecordingView: View {
    let borderColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel

    var body: some View {
        VStack() {
            HStack {
                ForEach(voiceNoteViewModel.soundSamples, id: \.self) { sampleValue in
                    WaveView(value: voiceNoteViewModel.normalizeSoundLevel(level: sampleValue))
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                .stroke(Color(borderColor), lineWidth: 2)
            )
        }
    }
    
}

extension VoiceNoteViewModel {
    func normalizeSoundLevel(level:Float) -> CGFloat {
        let soundLevel = max(0.2, CGFloat(level) + 50) / 2 // scale all received level in between 0.1 to 25
        return CGFloat(soundLevel * (100/25)) // set original bar height is 100
    }
}

struct AudioRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordingView().environmentObject(VoiceNoteViewModel(numberOfSample: samples))
    }
}
