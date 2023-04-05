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
    @Binding var showSheet:Bool
    
    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                showSheet = false
            } label: {
                VStack {
                    Image(systemName: "house")
                        .font(.system(size: 25))
                        .foregroundColor(Color(buttonColor))
                }
            }
            Spacer()
            Spacer()
            
            Button {
                clickAudioButton()
            } label: {
                Image(systemName: "\(voiceNoteViewModel.isRecording ? "square.fill" : "mic.fill")")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .padding(.all,20)
            .background(
                Circle()
                    .fill(Color(buttonColor))
            )
            .offset(y:-30)
            
            Spacer()
            Spacer()
            
            NavigationLink {
                RecordingListView()
            } label: {
                VStack {
                    Image(systemName: "list.dash")
                        .font(.system(size: 25))
                        .foregroundColor(Color(buttonColor))
                        .padding(.bottom,3)
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
    
    
    private func clickAudioButton() {
        voiceNoteViewModel.isRecording.toggle()
        print("Recording bool: \( voiceNoteViewModel.isRecording)")
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
            }
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(showSheet: .constant(false)).environmentObject(VoiceNoteViewModel(numberOfSample: samples)).environmentObject(SpeechRecognizer())
    }
}
