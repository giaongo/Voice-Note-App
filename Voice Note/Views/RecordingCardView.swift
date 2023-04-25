//
//  RecordingCardView.swift
//  Voice Note
//
//  Created by iosdev on 10.4.2023.
//

import SwiftUI

struct RecordingCardView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    @State var isPlayed: Bool = false
    private let borderColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    private var voiceNoteUrl: URL? = nil
    private var newList: [Float] {
        if voiceNoteViewModel.soundSamples.count != 0 {
            return voiceNoteViewModel.soundSamples.map { number in
                return number == -160.0 ? number + 160.2 : number
            }
        } else {
            return [-39.449028, -40.75847, -37.259445, -37.719852, -22.529305, -16.485308,-17.041458,-14.6853,-16.24986, -19.75164]
        }
    }
   
    init(voiceNoteUrl: URL?) {
        self.voiceNoteUrl = voiceNoteUrl
    }
    
    var body: some View {
        HStack() {
            ForEach(newList, id: \.self) { sampleValue in
                WaveView(value: voiceNoteViewModel.normalizeSoundLevel(level: sampleValue,barHeight: CGFloat(40)))
            }
            Button {
                isPlayed.toggle()
               /* if (voiceNoteUrl != nil || voiceNoteViewModel.fileUrlList.last != nil) {
                    isPlayed
                    ? voiceNoteViewModel.startPlaying(recordingUrl: voiceNoteUrl ?? (voiceNoteViewModel.fileUrlList.last ?? nil))
                    : voiceNoteViewModel.stopPlaying(recordingUrl: voiceNoteUrl ?? (voiceNoteViewModel.fileUrlList.last ?? nil))
                }*/
                guard let currentUrl = voiceNoteViewModel.fileUrlList.last else {
                                   return
                               }

                               isPlayed
                                   ? voiceNoteViewModel.startPlaying(recordingUrl: voiceNoteUrl ?? currentUrl)
                                   : voiceNoteViewModel.stopPlaying(recordingUrl: voiceNoteUrl ?? currentUrl)
                
                
            } label: {
                Image(systemName: voiceNoteViewModel.audioIsPlaying  ? "square.fill" : "play.fill").foregroundColor(.white)
                    .font(.system(size: 15))
                    .padding(.all,10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.black.shadow(.drop(color: Color(borderColor), radius: 2)))
                    )
                    .padding(.horizontal, 2)
            }
        }
        .frame(alignment: .leading)
        .padding(.all,10)
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color(borderColor), lineWidth: 2))
    }
}

struct RecordingCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingCardView(voiceNoteUrl: nil).environmentObject(VoiceNoteViewModel())
    }
}
