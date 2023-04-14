//
//  SlidingModalView.swift
//  Voice Note
//
//  Created by iosdev on 4.4.2023.
//

import SwiftUI

struct SlidingModalView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    @Binding var showSheet: Bool
    @Binding var toast:ToastView?
    
    var body: some View {
        ZStack() {
            Rectangle()
                .fill(.white)
                .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.4)
                .transition(.move(edge: .bottom))
                .cornerRadius(40, corners: [.topLeft, .topRight])
                .offset(y:50)
                .shadow(color: .black.opacity(0.6), radius: 10 , x: 8, y: 8)
            if voiceNoteViewModel.isRecording {
                AudioRecordingView()
            } else {
                AudioConfirmationView(showSheet: $showSheet, toast: $toast)
                .animation(.easeInOut, value: voiceNoteViewModel.isRecording)
            }
        }
        
    }
    

}

struct SlidingModalView_Previews: PreviewProvider {
    static var previews: some View {
        SlidingModalView(
            showSheet: .constant(false),
            toast: .constant(ToastView(type: .success, title: "Delete Success", message: "Delete successfully") {
            print("cancel on toast pressed")
            })).environmentObject(VoiceNoteViewModel())
    }
}
