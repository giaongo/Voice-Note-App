//
//  AudioConfirmationView.swift
//  Voice Note
//
//  Created by iosdev on 5.4.2023.
//

import SwiftUI

struct AudioConfirmationView: View {
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    
    var body: some View {
        VStack{
            Text("\(speechRecognizer.transcriptionText)").font(.headline).fontWeight(.bold).padding(.horizontal,10)
            HStack {
                Button {
                    if let newestRecordUrl = voiceNoteViewModel.fileUrlList.last {
                        voiceNoteViewModel.deleteRecording(url: newestRecordUrl)
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                }
                RecordingCardView()
            }
            
        }
    }
}


struct AudioConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        AudioConfirmationView().environmentObject(SpeechRecognizer()).environmentObject(VoiceNoteViewModel())
    }
}
