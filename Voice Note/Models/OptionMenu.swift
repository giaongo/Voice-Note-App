import Foundation
import CoreData

/**
    A type that holds option menus. It confronts to CaseIterable, Identifiable and Applicable
 */
enum OptionMenu: String, CaseIterable {
    case EDIT = "Edit"
    case DELETE = "Delete"

}

extension OptionMenu: Identifiable {
    var id: RawValue { rawValue }
}

extension OptionMenu: Applicable {
    func apply(_ item: NSManagedObject) {
        switch self {

        case .EDIT:
            print("Print from Enum: EDIT")

        case .DELETE:
            print("Print from Enum: DELETE")
            CoreDataService.localStorage.delete(item)
        }
    }
}
