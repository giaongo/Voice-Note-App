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
            print("Error getting VoiceNote by managedID: \(error.localizedDescription)")
        }

        return fetchedObject
    }

    func getVoiceNote(byFileURL fileURL: URL) -> [VoiceNote] {
        let managedContext = getManageObjectContext()
        let requestByFileURL: NSFetchRequest<VoiceNote> = VoiceNote.fetchRequest()
        requestByFileURL.predicate = NSPredicate(format: "fileUrl == %@", fileURL.absoluteString )
        var results: [VoiceNote?] = []
        do {
            results = try managedContext.fetch(requestByFileURL) as [VoiceNote]
        } catch {
            print("Error getting VoiceNote by byFileURL: \(error.localizedDescription)")
        }
        return results.compactMap{$0}
    }

    func getVoiceNote(byText text: String) -> [VoiceNote] {
        let managedContext = getManageObjectContext()
        let requestById: NSFetchRequest<VoiceNote> = VoiceNote.fetchRequest()
        requestById.predicate = NSPredicate(format: "id == %@", text )
        var results: [VoiceNote?] = []

        do {
            results = try managedContext.fetch(requestById) as [VoiceNote]
        } catch {
            print("Error getting VoiceNote by free text: \(error.localizedDescription)")
        }
        return results.compactMap{$0}
    }

    func getVoiceNote(byUUID uuid: UUID) -> VoiceNote {
        let managedContext = getManageObjectContext()
        let requestById: NSFetchRequest<VoiceNote> = VoiceNote.fetchRequest()
        requestById.predicate = NSPredicate(format: "id == %@", uuid.uuidString )
        var results: [VoiceNote?] = []

        do {
            results = try managedContext.fetch(requestById) as [VoiceNote]
        } catch {
            print("Error getting VoiceNote by uuid: \(error.localizedDescription)")
        }
        return results.compactMap{$0}[0]
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
