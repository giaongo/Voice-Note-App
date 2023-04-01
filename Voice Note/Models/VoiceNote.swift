//
// Created by Anwar Ulhaq on 1.4.2023.
//

import Foundation

class VoiceNote {
    var title: String
    var voiceNoteLocation: NoteLocation

    init(noteTitle title: String, voiceNoteLocation location: NoteLocation) {
        self.title = title
        self.voiceNoteLocation = location
    }
}
