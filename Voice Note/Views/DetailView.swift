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
    @Environment(\.presentationMode) var presentationMode
    @State private var showShareSheet = false
    let textContainer = #colorLiteral(red: 0.4, green: 0.2039215686, blue: 0.4980392157, alpha: 0.2)
    private let voiceNote: VoiceNote
    
    @State private var editableText: String
    @State private var isEditing = false
    
    init(voiceNote: VoiceNote) {
        self.voiceNote = voiceNote
        self._editableText = State(initialValue: voiceNote.text ?? "")
    }
    
    var body: some View {
        VStack {
            if isEditing {
                TextEditor(text: $editableText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(textContainer))
                    .cornerRadius(20)
                    .padding()
            } else {
                Text(editableText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(textContainer))
                    .cornerRadius(20)
                    .padding()
            }
            
            RecordingCardView(voiceNoteUrl: voiceNote.fileUrl).padding(15)
            Text("Duration: \(voiceNote.duration)s")
            HStack {
                // Direction button
                DetailBtn(clickHander: {
                    print("Direction pressed")
                }, icon: "arrow.triangle.turn.up.right.diamond.fill")
                
                //  Edit button
                DetailBtn(clickHander: {
                    toggleEditing()
                }, icon: "pencil")
                
                // Delete button
                DetailBtn(clickHander: {
                    deleteVoiceNote()
                }, icon: "trash")
                
                // Share button
                DetailBtn(clickHander: {
                    showShareSheet = true
                }, icon: "square.and.arrow.up")
                .sheet(isPresented: $showShareSheet, content: {
                    ShareSheet(activityItems: [voiceNote.text ?? ""])
                })
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
    
    private func toggleEditing() {
        isEditing.toggle()
        
        if !isEditing {
            voiceNote.text = editableText
            // Save the changes to the voice note text
            do {
                try voiceNote.managedObjectContext?.save()
            } catch {
                print("Error saving edited text: \(error)")
            }
        }
    }
    
    private func deleteVoiceNote() {
        let coreDataService = CoreDataService.localStorage
        coreDataService.delete(voiceNote)
        presentationMode.wrappedValue.dismiss()
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
        }.padding(.horizontal,20)
    }
}
    struct ShareSheet: UIViewControllerRepresentable {
        typealias UIViewControllerType = UIActivityViewController
        var activityItems: [Any]

        func makeUIViewController(context: Context) -> UIActivityViewController {
            let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            return controller
        }

        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
            // Nothing to update
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
