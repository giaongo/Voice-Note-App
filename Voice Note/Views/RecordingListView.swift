import SwiftUI
import CoreLocation

struct RecordingListView: View {
    @State var toast:ToastView? = nil
    @Environment(\.coreData) private var coreDataService: CoreDataService

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VoiceNote.createdAt, ascending: false)],
        animation: .default)
    private var items: FetchedResults<VoiceNote>

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(items, id: \.self) { item in
                        ListItem(voiceNote: item)
                    }.onDelete(perform: deleteItem)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                .padding(0)
            }
        }
        .toastView(toast: $toast)
        .navigationBarTitle("My Voice Notes")
    }
    
    /**
        This method displays sample data to the UI
     */
    private func addItem() {
        withAnimation {
            coreDataService.addFakeItem()
        }
    }

    /**
        This method removed the selected voice note
     */
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            coreDataService.delete(offsets)
        }
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
