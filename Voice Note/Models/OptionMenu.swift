import Foundation
import CoreData

/**
    This Model defines an enum named OptionMenu that has two cases: EDIT and DELETE
 */
enum OptionMenu: String, CaseIterable {
    case EDIT = "Edit"
    case DELETE = "Delete"

}

extension OptionMenu: Identifiable {
    var id: RawValue { rawValue }
}

extension OptionMenu: Applicable {
    // TODO pass object that confronts to Handleable protocol
    func apply(_ item: NSManagedObject) {
        switch self {

        case .EDIT:
            // TODO implement edit functionality here
            // TODO call handle function of passed parameter abject
            print("Print from Enum: EDIT")

        case .DELETE:
            // TODO implement delete functionality here
            print("Print from Enum: DELETE")
            CoreDataService.localStorage.delete(item)
        }
    }
}
