//
//  BottomBarView.swift
//  Voice Note
//
//  Created by Giao Ngo on 2.4.2023.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    @Binding var showSheet: Bool
    @State var showConfirmationAlert: Bool = false
    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    showSheet = false
                    voiceNoteViewModel.confirmTheVoiceNote = false
                } label: {
                    VStack {
                        Image(systemName: "house")
                            .font(.system(size: 25))
                            .foregroundColor(Color(buttonColor))
                    }
                }
                
                Spacer()
                
                VStack {
                    Button {
                        !voiceNoteViewModel.confirmTheVoiceNote ? clickAudioButton() : confirmToAddTheRecording()
                    } label: {
                        Image(systemName: "\(voiceNoteViewModel.isRecording ? "square.fill" : voiceNoteViewModel.confirmTheVoiceNote ? "checkmark" : "mic.fill")")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .padding(.all, 20)
                    .background(
                        Circle()
                            .fill(Color(buttonColor))
                    )
                    .offset(y: -30)
                    .alert("Important message", isPresented: $showConfirmationAlert) {
                        HStack {
                            Button("SAVE") {
                                print("Save pressed")
                            }
                            Button("CANCEL", role: .cancel) {
                                print("Cancel pressed")
                            }
                        }
                    }
                    
                    if voiceNoteViewModel.isMicPressed {
                        Button(action: {
                            if voiceNoteViewModel.isRecordingPaused {
                                voiceNoteViewModel.resumeRecording()
                            } else {
                                voiceNoteViewModel.pauseRecording()
                            }
                        }, label: {
                            Image(systemName: "\(voiceNoteViewModel.isRecordingPaused ? "play.fill" : "pause.fill")")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }).disabled(!voiceNoteViewModel.isRecording)
                            .padding(.all, 20)
                            .background(
                                Circle()
                                    .fill(Color(buttonColor))
                            )
                            .offset(y: -30)
                    }
                }
                
                Spacer()
                
                NavigationLink {
                    RecordingListView()
                } label: {
                    VStack {
                        Image(systemName: "list.dash")
                            .font(.system(size: 25))
                            .foregroundColor(Color(buttonColor))
                            .padding(.bottom, 3)
                    }
                }
                Spacer()
            }
            .background(
                VStack {
                    Divider()
                        .overlay(.black)
                    Spacer()
                }.background(.white)
            )
            .frame(height: 60)
        }
    }
    
    private func clickAudioButton() {
        voiceNoteViewModel.isRecording.toggle()
        voiceNoteViewModel.isMicPressed.toggle()
        if voiceNoteViewModel.isRecording {
            withAnimation {
                showSheet = true
            }
            speechRecognizer.reset()
            speechRecognizer.transcriptionText = ""
            voiceNoteViewModel.startRecording()
            
        } else {
            voiceNoteViewModel.stopRecording()
            if let newestRecordUrl = voiceNoteViewModel.fileUrlList.last {
                print("NewesrRecordUrl is \(newestRecordUrl)")
                speechRecognizer.transcribeFile(from: newestRecordUrl)
                voiceNoteViewModel.confirmTheVoiceNote = true
            }
        }
    }
    
    private func confirmToAddTheRecording(){
        showConfirmationAlert = true
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(showSheet: .constant(false)).environmentObject(VoiceNoteViewModel()).environmentObject(SpeechRecognizer())
    }
}
