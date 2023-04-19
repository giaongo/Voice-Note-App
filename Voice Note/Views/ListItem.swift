//
// Created by Anwar Ulhaq on 3.4.2023.
//
//

import SwiftUI

struct ListItem: View {
    let voiceNote: VoiceNote
    @State private var isOptionMenu = false
    @State private var isDeleteAlert = false
    @State private var defaultSelect = "None"
    @State private var showDetail = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                Text(voiceNote.title).bold()
                Spacer()
                Text(voiceNote.text)
                Spacer()
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.purple)
                            .onTapGesture {
                                print("COMING SOON: Show Voice not on map")
                            }
                    Text("\(voiceNote.near)")
                }
                Spacer()
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
                                    option.apply(voiceNote.title)
                                }
                            }
                        }
                Spacer()
                Text("\(voiceNote.duration.hoursAsTwoDigitString()):\(voiceNote.duration.minutesAsTwoDigitString()):\(voiceNote.duration.secondsAsTwoDigitString())")
                Spacer()
                Text("\(voiceNote.createdAt.formatted(.iso8601.day().month().year()))")
                        .padding(.bottom, 16.0)
            }
        }
    }
}

