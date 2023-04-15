//
//  SpeechRecognizer.swift
//  Voice Note
//
//  Created by Giao Ngo on 31.3.2023.
//  Learning resource on speech transcription:
//  1. https://medium.com/@kegoaps/audio-file-speech-transcription-using-sfspeechrecognizer-on-swiftui-5be019c81afe
//  2. https://developer.apple.com/documentation/speech/sfspeechurlrecognitionrequest
//

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

    /**
        This method displays the error message handling
     */
    private func displayError(_ error: Error) {
        var errorMessage: String = ""
        if let error = error as? RecognizeError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcriptionText = "Error dictating speech: \(errorMessage)"
    }
    
    /**
        This method transcribes the existing audio from document directory
     */
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
    
    
    /**
        This method stops the  text transcription
     */
    func stopTranscribing () {
        reset()
    }
    
    /**
        This method removes the speech transcription task
     */
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
