import SwiftUI
import CoreLocation

struct DetailView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showShareSheet = false
    let textContainer = #colorLiteral(red: 0.4, green: 0.2039215686, blue: 0.4980392157, alpha: 0.2)
    private let voiceNote: VoiceNote
    
    @State private var isEditing = false
    @State private var editText: String
    
    init(voiceNote: VoiceNote) {
        self.voiceNote = voiceNote
        _editText = State(initialValue: voiceNote.text ?? "")
    }
    
    var body: some View {
        VStack {
            if isEditing {
                TextEditor(text: $editText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(textContainer))
                    .cornerRadius(20)
                    .padding()
            } else {
                Text(voiceNote.text ?? "")
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
                }, icon: isEditing ? "checkmark.circle.fill" : "pencil")

                
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
    
    /**
        This method toggles editing when edit button is clicked
     */
    private func toggleEditing() {
        if isEditing {
            saveEditedText()
            voiceNoteViewModel.fetchVoiceNotes()
        }
        isEditing.toggle()
    }

    /**
        This method deletes the voice note from CoreData
     */
    private func deleteVoiceNote() {
        let context = PersistenceController.shared.container.viewContext
        context.delete(voiceNote)
        do {
            try context.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error deleting voice note: \(error)")
        }
    }
    
    /**
        This method update the editted text to CoreData
     */
    private func saveEditedText() {
        let context = PersistenceController.shared.container.viewContext
        voiceNote.text = editText
        do {
            try context.save()
        } catch {
            print("Error saving edited text: \(error)")
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
}
