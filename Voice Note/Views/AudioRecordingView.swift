import SwiftUI

struct AudioRecordingView: View {
    @State var message: String = ""
    @StateObject var speechRecognizer = SpeechRecognizer()
    @ObservedObject var voiceNoteViewModel = VoiceNoteViewModel()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack() {
                Text("Recording scene")
                Spacer()
                Text("Transcription message")
                Text("\(speechRecognizer.transcriptionText)")
                Spacer()
                BottomBarView(message: $message, speechRecognizer: speechRecognizer, voiceNoteViewModel: voiceNoteViewModel)
            }
        }
    }
}

struct AudioRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordingView()
    }
}
