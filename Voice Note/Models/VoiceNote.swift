//
// Created by Anwar Ulhaq on 1.4.2023.
//

import Foundation
import CoreLocation

//
struct VoiceNote: Identifiable/*, Decodable, Codable*/ {
    let id: UUID
    var text: String
    var title: String
    var near: String
    var duration: TimeDuration
    //let fileUrl: URL
    let createdAt: Date
    //var isPlaying: Bool
    var location: CLLocation

    init(noteId id: UUID, noteTitle title: String, noteText text: String, noteDuration duration: TimeDuration, noteCreatedAt createdAt: Date, noteTakenNear near: String, voiceNoteLocation location: CLLocation) {
        self.id = id
        self.title = title
        self.text = text
        self.location = location
        self.near = near
        self.duration = duration
        self.createdAt = createdAt
    }
}
