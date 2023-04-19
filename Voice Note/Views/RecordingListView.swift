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
    @State var toast:ToastView? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach((1...10), id: \.self) {
                        ListItem (
                            voiceNote: VoiceNote(
                                noteId: UUID(),
                                noteTitle: "Note - \($0)",
                                noteText: "This place is good to come back in the summer. There are a lot of mushrooms and berries to pick up. Take good camera lens with me also for a good lanscape shot",
                                noteDuration: TimeDuration(size: 3765),
                                noteCreatedAt: Date.init(),
                                noteTakenNear: "Ruoholahti",
                                voiceNoteLocation: CLLocation(latitude: 24.33, longitude: 33.56)
                            ))
                    }
                }
                .padding(0)
            }
            
        }
        .toastView(toast: $toast)
        .navigationBarTitle("My Voice Notes")
    }
}

struct RecordingListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingListView(
            toast: ToastView(type: .success, title: "Delete Success", message: "Delete successfully") {
                print("cancel on toast pressed")
            })
        .environmentObject(VoiceNoteViewModel())
    }
}
