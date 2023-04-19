//
//  RecordingListView.swift
//  Voice Note
//
//  Created by iosdev on 2.4.2023.
//

import SwiftUI
import CoreLocation

struct RecordingListView: View {
    @State var toast:ToastView? = nil
    //@Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.coreData) private var coreDataService: CoreDataService

    // Item will get fetched when RecordingListView loads
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VoiceNote.id, ascending: true)],
            animation: .default)
    private var items: FetchedResults<VoiceNote>
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(items, id: \.self) { item in
                        ListItem (voiceNote: item)
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
                .padding(0)
            }
        }
        .toastView(toast: $toast)
        .navigationBarTitle("My Voice Notes")
    }

    private func addItem() {
        withAnimation {
            coreDataService.addFakeItem()
        }
    }

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
