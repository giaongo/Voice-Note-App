//
// Created by Anwar Ulhaq on 1.4.2023.
//

import Foundation

enum RecognizeError: Error {
    case nilRecognizer
    case notAuthorizedToRecognize
    case notPermittedToRecord
    case recognizerIsUnavailable
    case errorInRecognizing

    var message:String {
        switch self {
        case .nilRecognizer: return "Can't initialize speech recognizer"
        case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
        case .notPermittedToRecord: return "Not permitted to record audio"
        case .recognizerIsUnavailable: return "Recognizer is unavailable"
        case .errorInRecognizing: return "Recognizing encounters error"
        }
    }
}
