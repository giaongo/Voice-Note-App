import Foundation
import AVFoundation
import Speech

class SpeechRecognizer: ObservableObject {
    
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    
    @Published var transcriptionText: String = ""
    
    init() {
        recognizer = SFSpeechRecognizer()
        checkAuthorizationStatus()
    }
    
    deinit {
        reset()
    }
    
    private func checkAuthorizationStatus() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    AVAudioSession.sharedInstance().requestRecordPermission { allowed in
                        DispatchQueue.main.async {
                            if !allowed {
                                self.displayError(RecognizeError.notPermittedToRecord)
                            }
                        }
                    }
                default:
                    self.displayError(RecognizeError.notAuthorizedToRecognize)
                }
            }
        }
    }
    
    private func displayError(_ error: Error) {
        var errorMessage: String = ""
        if let error = error as? RecognizeError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcriptionText = "Error dictating speech \(errorMessage)"
    }
    
    func transcribeFile(from url:URL){
        DispatchQueue(label:"Speech Recognition Queue", qos:.userInteractive).async {
            [weak self] in
            guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
                self?.displayError(RecognizeError.recognizerIsUnavailable)
                return
            }
            
            let request = SFSpeechURLRecognitionRequest(url: url)
            recognizer.recognitionTask(with: request) { (result, error) in
                guard let result = result else {
                    self.displayError(RecognizeError.errorInRecognizing)
                    return
                }
                if result.isFinal {
                    self.transcriptionText = result.bestTranscription.formattedString
                    self.stopTranscribing()
                }
            }
        }
    }
    
    func stopTranscribing () {
        reset()
    }
    
    func reset() {
        task?.cancel()
        task = nil
    }
}
