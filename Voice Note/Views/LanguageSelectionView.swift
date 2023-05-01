

import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    @Binding var isPresented: Bool
    
    // Get the list of available language codes
    private let languages = Locale.availableIdentifiers
        .map { Locale(identifier: $0).localizedString(forIdentifier: $0) ?? "" }
        .filter { !$0.isEmpty }
        .sorted()
        .map { ($0, $0) }
    
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
