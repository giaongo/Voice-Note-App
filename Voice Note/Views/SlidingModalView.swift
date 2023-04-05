//
//  SlidingModalView.swift
//  Voice Note
//
//  Created by iosdev on 4.4.2023.
//

import SwiftUI

struct SlidingModalView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.4)
                .transition(.move(edge: .bottom))
                .cornerRadius(40, corners: [.topLeft, .topRight])
            if voiceNoteViewModel.isRecording {
                AudioRecordingView()
            } else {
                AudioConfirmationView().animation(.easeInOut, value: voiceNoteViewModel.isRecording)
            }
            
        }
        
    }
}

struct SlidingModalView_Previews: PreviewProvider {
    static var previews: some View {
        SlidingModalView()
    }
}
