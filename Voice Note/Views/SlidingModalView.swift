//
//  SlidingModalView.swift
//  Voice Note
//
//  Created by iosdev on 4.4.2023.
//

import SwiftUI

struct SlidingModalView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    @Binding var showSheet: Bool
    @Binding var toast:ToastView?
    var body: some View {
        ZStack() {
            Rectangle()
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.3)
                .transition(.move(edge: .bottom))
                .cornerRadius(40, corners: [.topLeft, .topRight])
            if voiceNoteViewModel.isRecording {
                AudioRecordingView()
            } else {
                AudioConfirmationView(showSheet: $showSheet, toast: $toast).animation(.easeInOut, value: voiceNoteViewModel.isRecording)
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
            }))
    }
}
