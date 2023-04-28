import SwiftUI


@main
struct Voice_NoteApp: App {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @StateObject var voiceNoteViewModel = VoiceNoteViewModel()
    //@StateObject var mapViewModel = MapViewModel()
    let coreDataService = CoreDataService.localStorage

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                        .environment(\.managedObjectContext, coreDataService.getManageObjectContext())
                        .environment(\.coreData, coreDataService)
            }.environmentObject(speechRecognizer).environmentObject(voiceNoteViewModel)
        }
    }
}

extension CoreDataService: EnvironmentKey {
    static let defaultValue: CoreDataService = CoreDataService.localStorage
}

extension EnvironmentValues {
    internal var coreData: CoreDataService {
        get {
            self[CoreDataService.self]
        }
        set {
            self[CoreDataService.self] = CoreDataService.localStorage
        }
    }
}
