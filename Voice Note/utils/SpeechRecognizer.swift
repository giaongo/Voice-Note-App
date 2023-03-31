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
    
    deinit {
        reset()
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
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true,  options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {(buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        return (audioEngine, request)
    }
    
    /**
     This creates a speech recognition task to transcibe speech to text. The result is writtent to public transcriptionText until stopTransribing method is called
     */
    func transcribe() {
        DispatchQueue(label: "Speech Recognition Queue", qos:.background).async {
            [weak self] in
            guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
                self?.displayError(RecognizeError.recognizerIsUnavailable)
                return
            }
            do {
                let (audioEngine, request) = try Self.prepareEngine()
                self.audioEngine = audioEngine
                self.request = request
                self.task = recognizer.recognitionTask(with: request, resultHandler: self.recognitionHandler(result:error:))
            } catch {
                self.reset()
                self.displayError(error)
            }
        }
    }
    
    /**
     This stops transcription
     */
    func stopTranscibing () {
        reset()
    }
    
    func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private func recognitionHandler (result: SFSpeechRecognitionResult?, error:Error?) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil
        if receivedFinalResult || receivedError {
            audioEngine?.stop()
            audioEngine?.inputNode.removeTap(onBus: 0)
        }
        if let result = result {
            transciptionText = result.bestTranscription.formattedString
        }
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
