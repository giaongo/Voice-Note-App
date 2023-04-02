//
//  RecordingListView.swift
//  Voice Note
//
//  Created by iosdev on 2.4.2023.
//

import SwiftUI

struct RecordingListView: View {
    @ObservedObject var voiceNoteViewModel = VoiceNoteViewModel()
    var body: some View {
        VStack {
            Text("Recordings: \(voiceNoteViewModel.recordingList.count)")
            Spacer()
            ForEach(voiceNoteViewModel.recordingList, id: \.createdAt) { recording in
                VStack {
                    Text("Recording file is: \(recording.fileUrl.lastPathComponent)")
                }
            }
            
        }
        
    }
}

struct RecordingListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingListView()
    }
}
