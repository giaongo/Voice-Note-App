//
//  SpeechRecognizer.swift
//  Voice Note
//
//  Created by iosdev on 31.3.2023.
//

import Foundation
import AVFoundation
import Speech
import SwiftUI

class SpeechRecognizer: ObservableObject {
    
    enum RecognizeError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message:String {
            switch self {
            case .nilRecognizer: return "Can't iniialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    
    var transciptionText: String = ""
    
    init() {
        recognizer = SFSpeechRecognizer()
        Task(priority: .background) {
            do {
                guard recognizer != nil else {
                    throw RecognizeError.nilRecognizer
                }
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizeError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizeError.notPermittedToRecord
                }
            } catch {
                displayError(error)
            }
        }
    }
    
    /**
     This displays error message handling
     */
    private func displayError(_ error: Error) {
        var errorMessage: String = ""
        if let error = error as? RecognizeError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transciptionText = "Error dictacting speech \(errorMessage)"
    }
    
}
extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation({ continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        })
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation({ continuation in
            requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        })
    }
}
