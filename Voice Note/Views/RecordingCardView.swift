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

    var body: some View {
        HStack() {
            if voiceNoteViewModel.soundSamples.count != 0 {
                let newList = voiceNoteViewModel.soundSamples.map { number in
                    return number == -160.0 ? number + 160.2 : number
                }
                ForEach(newList, id: \.self) { sampleValue in
                    WaveView(value: voiceNoteViewModel.normalizeSoundLevel(level: sampleValue,barHeight: CGFloat(40)))
                }
            }
            Button {
                isPlayed.toggle()
                if let newestRecordUrl = voiceNoteViewModel.fileUrlList.last {
                    isPlayed
                    ? voiceNoteViewModel.startPlaying(recordingUrl: newestRecordUrl)
                    : voiceNoteViewModel.stopPlaying(recordingUrl: newestRecordUrl)
                }
                
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
        .onAppear {
            print("What happened if things end after 10s: \(voiceNoteViewModel.soundSamples.count)")
        }
        .frame(alignment: .leading)
        .padding(.all,10)
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color(borderColor), lineWidth: 2))
    }
}

struct RecordingCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingCardView().environmentObject(VoiceNoteViewModel())
    }
}
