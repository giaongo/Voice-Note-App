//
//  BottomBarView.swift
//  Voice Note
//
//  Created by Giao Ngo on 2.4.2023.
//

import SwiftUI

struct BottomBarView: View {
    @Binding var message: String
    @ObservedObject var voiceNoteViewModel = VoiceNoteViewModel()
    
    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                print("Home pressed")
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
                Image(systemName: "\(voiceNoteViewModel.isRecording ? "mic" : "mic.fill")")
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
                Spacer()
            }
        )
        .frame(height: 60)
    }
    
    
    private func clickAudioButton() {
        voiceNoteViewModel.isRecording.toggle()
        if voiceNoteViewModel.isRecording {
            print("Start recording")
            voiceNoteViewModel.startRecording()
        } else {
            print("Stop recording")
            voiceNoteViewModel.stopRecording()
        }
    }
}

