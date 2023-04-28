import SwiftUI

struct ListItem: View {
    @ObservedObject var voiceNote: VoiceNote
    @State private var isOptionMenu = false
    @State private var isDeleteAlert = false
    @State private var defaultSelect = "None"
    @State private var showDetail = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                Text(voiceNote.title ?? "").bold()
                Spacer()
                // TODO, remove later these location parameters
                // Text(String(format: "%.6f", voiceNote.location?.longitude ?? 0.0))
                Spacer()
                // Text(String(format: "%.6f", voiceNote.location?.latitude ?? 0.0))
                Spacer()
                Text(voiceNote.text ?? "")
                Spacer()
                HStack {
                    /*Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.purple)
                            .onTapGesture {
                                print("COMING SOON: Show Voice not on map")
                            }
                    Text("\(voiceNote.near ?? "")")*/
                    //Text("Average: \(String(voiceNote.weather?.temperature?.average ?? 0))")
                    Text("Minimum: \(String(voiceNote.weather?.temperature?.minimum ?? 0))")
                    Text("Maximum: \(String(voiceNote.weather?.temperature?.maximum ?? 0))")

                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Image(systemName: "ellipsis.circle")
                    .imageScale(.large)
                    .foregroundColor(.purple)
                    .padding(.top, 16.0)
                    .onTapGesture {
                        isOptionMenu = true
                    }
                    .confirmationDialog("Select a option", isPresented: $isOptionMenu) {
                        ForEach(OptionMenu.allCases) { option in
                            Button(option.rawValue) {
                                defaultSelect = option.rawValue
                                print("Option selected: \(option)")
                                print("Type of Option selected: \(type(of: option))")
                                option.apply(voiceNote)
                            }
                        }
                    }
                Spacer()
                Spacer()
                Text("\(Date.init().formatted(.iso8601.day().month().year()))")
                    .padding(.bottom, 16.0)
            }
        }
        .onTapGesture {
            showDetail = true
        }
        .sheet(isPresented: $showDetail) {
            if let id = voiceNote.id {
                DetailView(voiceNoteUUID: id)
            }
        }
    }
}
