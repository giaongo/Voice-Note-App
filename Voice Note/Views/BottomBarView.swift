import SwiftUI

struct BottomBarView: View {
    @Binding var message: String
    @ObservedObject var voiceNoteViewModel: VoiceNoteViewModel
    @ObservedObject var speechRecognizer: SpeechRecognizer
    let buttonColor = Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    print("Home pressed")
                } label: {
                    VStack {
                        Image(systemName: "house")
                            .font(.system(size: 25))
                            .foregroundColor(buttonColor)
                    }
                }
                
                Spacer()
                Spacer()
                
                Button {
                    clickAudioButton()
                } label: {
                    Image(systemName: "\(voiceNoteViewModel.isRecording ? "stop.fill" : "mic.fill")")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                .padding(.all,20)
                .background(
                    Circle()
                        .fill(buttonColor)
                )
                .offset(y:-30)
                Spacer()
                Spacer()
                
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
                .padding(.all,20)
                .background(
                    Circle()
                        .fill(buttonColor)
                )
                .offset(y:-30)
                
                Spacer()
                
                NavigationLink {
                    RecordingListView()
                } label: {
                    VStack {
                        Image(systemName: "list.dash")
                            .font(.system(size: 25))
                            .foregroundColor(buttonColor)
                            .padding(.bottom,3)
                    }
                    
                }
            }
            .background(
                VStack {
                    Divider()
                    Spacer()
                }
            )
            .frame(height: 60)
        }
    }
    
    private func clickAudioButton() {
        voiceNoteViewModel.isRecording.toggle()
        if voiceNoteViewModel.isRecording {
            voiceNoteViewModel.startRecording()
            speechRecognizer.reset()
            speechRecognizer.transcriptionText = ""
        } else {
            voiceNoteViewModel.stopRecording()
            if let newestRecordUrl = voiceNoteViewModel.fileUrlList.last {
                speechRecognizer.transcribeFile(from: newestRecordUrl)
            }
        }
    }
}
