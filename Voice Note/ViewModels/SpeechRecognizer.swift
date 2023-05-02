import Foundation
import AVFoundation
import Speech
import SwiftUI

/**
    A class who's instance will do speech recognition
 */
class SpeechRecognizer: ObservableObject {
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?
    @Published var transcriptionText: String = ""
    @Published var selectedLanguageIndex: Int = 0
    private var languages: [(name: String, identifier: String)] = []
    @Published var filteredLanguages: [(name: String, identifier: String)] = []

    init() {
        setAvailableLanguages()
        setLocale(languageCode: languages[selectedLanguageIndex].identifier)
        checkAuthorizationStatus()
        filterLanguages("")
    }

    private func setAvailableLanguages() {
        languages = Locale.availableIdentifiers.compactMap { identifier in
            guard let languageName = Locale(identifier: identifier).localizedString(forLanguageCode: identifier) else {
                return nil
            }
            return (languageName, identifier)
        }.sorted { $0.name < $1.name }
    }

    func setLocale(languageCode: String) {
        let language = Locale(identifier: languageCode)
        let locale = Locale(identifier: language.languageCode!)
        recognizer = SFSpeechRecognizer(locale: locale)
    }

    func checkAuthorizationStatus() {
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

    func displayError(_ error: Error) {
        var errorMessage: String = ""
        if let error = error as? RecognizeError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcriptionText = "Error dictating speech: \(errorMessage)"
    }

    func transcribeFile(from url: URL) {
        let languageCode = languages[selectedLanguageIndex].identifier
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
    
    func filterLanguages(_ searchText: String) {
        if searchText.isEmpty {
            filteredLanguages = languages
        } else {
            filteredLanguages = languages.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
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
