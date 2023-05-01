import Foundation
import AVFoundation
import Speech

class SpeechRecognizer: ObservableObject {
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?
    @Published var transcriptionText: String = ""
    @Published var selectedLanguageIndex: Int = 0
    private let languages = [("English", "en"), ("Bangla", "bn"), ("Finnish", "fi"), ("Swedish", "sv"), ("Chinese", "zh-Hans"), ("Vietnamese", "vi"), ("Russian", "ru")]


    init() {
        setLocale(languageCode: languages[selectedLanguageIndex].1)
        checkAuthorizationStatus()
    }

    func setLocale(languageCode: String) {
        recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: languageCode))
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
        transcriptionText = "Error dictating speech: \(errorMessage)"
    }

    func transcribeFile(from url: URL) {
        let languageCode = languages[selectedLanguageIndex].1
            setLocale(languageCode: languageCode)
        DispatchQueue(label: "Speech Recognition Queue", qos: .userInteractive).async {
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

    func stopTranscribing() {
        reset()
    }

    func reset() {
        task?.cancel()
        task = nil
    }
}

extension SFSpeechRecognizer {
    /**
     This method requests the speech recognition permission
     */
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation({ continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        })
    }
}

extension AVAudioSession {
    /**
     This method records the audio permission
     */
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation({ continuation in
            requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        })
    }
}
