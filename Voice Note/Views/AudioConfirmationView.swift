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
    @Binding var toast:ToastView?
    
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
                RecordingCardView(voiceNoteUrl: nil)
            }
        }
        .onAppear {
            if let newestRecordUrl = voiceNoteViewModel.fileUrlList.last {
                toast = ToastView(type: .info, title: "Recording Activity Ended", message: "Recording stopped by button press or reached 10s limit.") {}
                speechRecognizer.transcribeFile(from: newestRecordUrl)
            }
        }
        .alert("Are you sure you want to delete?", isPresented: $showDeleteConfimation) {
            HStack {
                Button("DELETE") {
                    if let newestRecordUrl = voiceNoteViewModel.fileUrlList.last {
                        voiceNoteViewModel.deleteRecording(url: newestRecordUrl)
                        voiceNoteViewModel.confirmTheVoiceNote = false
                        showSheet = false
                        toast = ToastView(type: .success, title: "Delete success", message: "Delete audio successfully", cancelPressed: {
                            print("cancel on toast pressed")
                        })
                    } else {
                        toast = ToastView(type:.error, title: "Unable to delete", message: "Deleting audio failed", cancelPressed: {
                            print("cancel on toast pressed")
                        })
                    }

                }
                Button("CANCEL", role: .cancel) {
                    print("Cancel delete pressed")
                }
            }
            
        }
    }
    
    private func transcriptionText() {
        print("this is called")
        if (!voiceNoteViewModel.isRecording) {
            if let newestRecordUrl = voiceNoteViewModel.fileUrlList.last {
                speechRecognizer.transcribeFile(from: newestRecordUrl)
            }
        }
    }
}


struct AudioConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        AudioConfirmationView(
            showSheet: .constant(false),
            toast: .constant(ToastView(type: .success, title: "Delete Success", message: "Delete successfully") {
            print("canceled on toast pressed")
            }))
            .environmentObject(SpeechRecognizer()).environmentObject(VoiceNoteViewModel())
    }
}
