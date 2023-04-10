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
    @State var showDeleteConfimation: Bool = false
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack{
            Text("\(speechRecognizer.transcriptionText)").font(.headline).fontWeight(.bold).padding(.horizontal,10)
            HStack {
                Button {
                    showDeleteConfimation = true
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                }
                RecordingCardView()
            }
        }.alert("Are you sure you want to delete", isPresented: $showDeleteConfimation) {
            HStack {
                Button("DELETE") {
                    if let newestRecordUrl = voiceNoteViewModel.fileUrlList.last {
                        voiceNoteViewModel.deleteRecording(url: newestRecordUrl)
                        voiceNoteViewModel.confirmTheVoiceNote = false
                        showSheet = false
                    }
                }
                Button("CANCEL", role: .cancel) {
                    print("Cancel pressed")
                }
            }
        }
    }
}


struct AudioConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        AudioConfirmationView(showSheet: .constant(false)).environmentObject(SpeechRecognizer()).environmentObject(VoiceNoteViewModel())
    }
}
