//
//  RecordingListView.swift
//  Voice Note
//
//  Created by iosdev on 2.4.2023.
//

import SwiftUI
import CoreLocation

struct RecordingListView: View {
    @EnvironmentObject var voiceNoteViewModel:VoiceNoteViewModel
    var body: some View {
        NavigationStack {
            List {
                ForEach(voiceNoteViewModel.recordingList) { recording in
                    ListItem (
                            voiceNote: VoiceNote(
                                    noteId: recording.id,
                                    noteTitle: "Note - \(recording.id)",
                                    noteText: "Rekjh falk sdlfka hsldkj fhkasdh lkfsd",
                                    noteDuration: TimeDuration(size: 3765),
                                    noteCreatedAt: Date.init(),
                                    noteTakenNear: "Ruoholahti",
                                    voiceNoteLocation: CLLocation(latitude: 24.33, longitude: 33.56)
                    ))
                }
                }
        }.navigationBarTitle("My Voice Notes")
    }
}

struct RecordingListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingListView().environmentObject(VoiceNoteViewModel())
    }
}
