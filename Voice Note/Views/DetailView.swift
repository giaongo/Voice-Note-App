//
//  DetailView.swift
//  Voice Note
//
//  Created by Giao Ngo on 18.4.2023.
//

import SwiftUI
import CoreLocation

struct DetailView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    let textContainer = #colorLiteral(red: 0.4, green: 0.2039215686, blue: 0.4980392157, alpha: 0.2)
    private let voiceNote: VoiceNote
    
    init(voiceNote:VoiceNote) {
        self.voiceNote = voiceNote
    }
    var body: some View {
        VStack {
            Text(voiceNote.text ?? "")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(textContainer))
                .cornerRadius(20)
                .padding()
            
            RecordingCardView().padding(15)
            Text("Duration: 23s")
            HStack {
                // Direction button
                DetailBtn(clickHander: {
                    print("Direction pressed")
                }, icon: "arrow.triangle.turn.up.right.diamond.fill")
                
                //  Edit button
                DetailBtn(clickHander: {
                    print("Edit pressed")
                }, icon: "pencil").disabled(true)
                
                // Delete button
                DetailBtn(clickHander: {
                    print("Delete pressed")
                }, icon: "trash")
                
                // Share button
                DetailBtn(clickHander: {
                    print("Share pressed")
                }, icon: "square.and.arrow.up").disabled(true)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

struct DetailBtn: View {
    let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    let clickHander: () -> Void
    let icon: String
    
    var body: some View {
        Button {
            clickHander()
        } label: {
            Image(systemName: icon)
                .font(.title2)
                .padding(10)
                .background(Color(.systemGray6))
                .clipShape(Circle())
                .foregroundColor(Color(buttonColor))
        }.padding(.horizontal,20).disabled(true)
    }
}
/*struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(voiceNote: VoiceNote(
            noteId: UUID(),
            noteTitle: "Note - 1",
            noteText: "Rekjh falk sdlfka hsldkj fhkasdh lkfsd",
            noteDuration: TimeDuration(size: 3765),
            noteCreatedAt: Date.init(),
            noteTakenNear: "Ruoholahti",
            voiceNoteLocation: CLLocation(latitude: 24.33, longitude: 33.56)
        ))
    }
}
*/
