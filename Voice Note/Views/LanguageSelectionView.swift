//
//  LanguageSelectionView.swift
//  Voice Note
//
//  Created by Mohammad Rashid on 30.4.2023.
//

import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    @Binding var isPresented: Bool
    private let languages = [("English", "en"), ("Bangla", "bn"), ("Finnish", "fi"), ("Swedish", "sv"), ("Chinese", "zh-Hans"), ("Vietnamese", "vi"), ("Russian", "ru")]

    private func dismiss() {
        isPresented = false
    }

    var body: some View {
        VStack {
            Text("Select Language")
                .font(.title)
                .padding(.bottom, 20)

            Picker("Language", selection: $speechRecognizer.selectedLanguageIndex) {
                ForEach(0..<languages.count, id: \.self) { index in
                    Text(languages[index].0).tag(index)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .onChange(of: speechRecognizer.selectedLanguageIndex, perform: { _ in
                dismiss()
            })
        }
        .padding()
    }
}

struct LanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelectionView(isPresented: .constant(true)).environmentObject(SpeechRecognizer())
    }
}
