//
// Created by Anwar Ulhaq on 3.4.2023.
//
//

import SwiftUI

struct ListItem: View {
    @ObservedObject var voiceNote: VoiceNote
    @State private var isOptionMenu = false
    @State private var isDeleteAlert = false
    @State private var defaultSelect = "None"
    @State private var showDetail = false
    

    //private func formattedDuration(for duration: Int) -> String {
       // let hours = duration / 3600
      //  let minutes = (duration % 3600) / 60
       // let seconds = duration % 60
       // return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
   // }
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
              //  Text(formattedDuration(for: Int(voiceNote.duration)))
                Spacer()
                Text("\(Date.init().formatted(.iso8601.day().month().year()))")
                        .padding(.bottom, 16.0)
            }
        }
        .onTapGesture {
            showDetail = true
        }
        .sheet(isPresented: $showDetail) {
            DetailView(voiceNote: voiceNote)
        }
    }
}
