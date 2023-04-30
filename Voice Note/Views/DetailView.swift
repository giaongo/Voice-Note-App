import SwiftUI
import CoreLocation

struct DetailView: View {
    @EnvironmentObject var voiceNoteViewModel: VoiceNoteViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.coreData) private var coreDataService: CoreDataService
    @State private var showShareSheet = false
    let textContainer = #colorLiteral(red: 0.4, green: 0.2039215686, blue: 0.4980392157, alpha: 0.2)
    private let voiceNote: VoiceNote?
    
    @State private var isEditing = false
    @State private var editText: String
    
    init(voiceNoteUUID uuid: UUID) {
            voiceNote = CoreDataService.localStorage.getVoiceNote(byUUID: uuid)
        _editText = State(initialValue: voiceNote?.text ?? "Title Missing")
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
                Text(voiceNote?.text ?? "")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(textContainer))
                    .cornerRadius(20)
                    .padding()
            }
            
            RecordingCardView(voiceNoteUrl: voiceNote?.fileUrl).padding(15)
            Text("Duration: \(voiceNote?.duration ?? 0)s")
            
           
            
            HStack {
                // Direction button
                DetailBtn(clickHandler: {
                    print("Direction pressed")
                }, icon: "arrow.triangle.turn.up.right.diamond.fill")
                
                //  Edit button
                DetailBtn(clickHandler: {
                    toggleEditing()
                }, icon: isEditing ? "checkmark.circle.fill" : "pencil")

                
                // Delete button
                DetailBtn(clickHandler: {
                    deleteVoiceNote()
                }, icon: "trash")
                
                // Share button
                DetailBtn(clickHandler: {
                    showShareSheet = true
                }, icon: "square.and.arrow.up")
                .sheet(isPresented: $showShareSheet, content: {
                    ShareSheet(activityItems: [voiceNote?.text ?? ""])
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
        let context = coreDataService.getManageObjectContext()
        if let voiceNote = voiceNote {
            let url = voiceNote.fileUrl
            //delete from DB
            context.delete(voiceNote)
            //delete local file
            if let url = url {
                voiceNoteViewModel.deleteRecording(url: url)
            }
            // repopulate file URL array
            voiceNoteViewModel.fetchVoiceNotes()
            // repopulate map
            mapViewModel.populateLocation()
            do {
                try context.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Error deleting voice note: \(error)")
            }
        }
    }
    
    /**
        This method update the edited text to CoreData
     */
    private func saveEditedText() {
        let context = PersistenceController.shared.container.viewContext
        voiceNote?.text = editText
        do {
            try context.save()
        } catch {
            print("Error saving edited text: \(error)")
        }
    }
    
    struct DetailBtn: View {
        let buttonColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        let clickHandler: () -> Void
        let icon: String
        
        var body: some View {
            Button {
                clickHandler()
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
