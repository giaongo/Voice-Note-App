import Foundation
import CoreData

/**
    A class that contains methods associated with CoreData operation
 */
class CoreDataService {
    static let localStorage = CoreDataService()
    private let persistenceController = PersistenceController.shared

    // May be we fetch from remote location in future
    private init(remoteFetch: Bool = false) {
        // console logs SQLite file location for viewing DB
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print("DataBase SQLite file can be found at this location,")
            print(url.absoluteString)
        }
    }

    func getManageObjectContext() -> NSManagedObjectContext {
        persistenceController.container.viewContext
    }

    // TODO Remove this at the end
    func addFakeItem () {
        print("Fake Item function called")

        let newVoiceNote = VoiceNote(context: persistenceController.container.viewContext)
        let id = UUID()

        newVoiceNote.id = id
        newVoiceNote.text = "this is my voicenote text"
        newVoiceNote.title = "Note title"
        newVoiceNote.near = "Kamppi"
        newVoiceNote.fileUrl = URL(fileURLWithPath: "/dev/secure/storage")
        newVoiceNote.duration = 3765
        newVoiceNote.createdAt = Date.init()
        newVoiceNote.location = Location(context: persistenceController.container.viewContext)
        newVoiceNote.location?.id = id
        newVoiceNote.location?.longitude = Double.random(in: 24.600750..<25.30750)//24.444
        newVoiceNote.location?.latitude = Double.random(in: 60.090760..<60.430440)
        newVoiceNote.weather = Weather(context: persistenceController.container.viewContext)
        newVoiceNote.weather?.temperature = Temperature(context: persistenceController.container.viewContext)
        //newVoiceNote.weather?.temperature?.average = 34
        newVoiceNote.weather?.temperature?.maximum = 44
        newVoiceNote.weather?.temperature?.minimum = 24

        do {
            try persistenceController.container.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func loadLatestTemperatures() {

    }

    func fetchAllVoiceNotes() -> [VoiceNote] {
        var voiceNotes: [VoiceNote] = []
        let managedContext = persistenceController.container.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "VoiceNote")
        do {
            voiceNotes = try managedContext.fetch(fetchRequest) as? [VoiceNote] ?? []
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            //return nil
        }
        return voiceNotes
    }

    func getAllLocations() -> [Location] {
        fetchAllVoiceNotes()
                .map { voiceNote -> Location? in voiceNote.location}
                .compactMap {$0}
    }

    func getVoiceNote(byManagedObjectID managedObjectID: NSManagedObjectID) -> VoiceNote? {
        let managedContext = getManageObjectContext()

        var fetchedObject = VoiceNote(context: managedContext)


        do {
            fetchedObject = try managedContext.existingObject(with: managedObjectID) as! VoiceNote
        } catch {
            // TODO handle error
        }

        return fetchedObject
    }

    func getVoiceNote(byFileURL fileURL: URL) {

    }

    // TODO remove this way of deleting, calling method should pass NSManagedObject from offsets.
    func delete(_ offsets: IndexSet) {
        print("Delete item from coredata: \(offsets)")
        let managedContext = persistenceController.container.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "VoiceNote")

        // TODO remove recording file from file system too.
        do {
            let items = try managedContext.fetch(fetchRequest)
            offsets.map {items[$0] }.forEach(managedContext.delete)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            //return nil
        }
    }
    func delete(_ item: NSManagedObject) {
        let managedContext = persistenceController.container.viewContext
        do {
            try managedContext.delete(item)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
