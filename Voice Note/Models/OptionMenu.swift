// 
// Created by Anwar Ulhaq on 4.4.2023.
//
//

import Foundation

enum OptionMenu: String, CaseIterable {
    case EDIT = "Edit"
    case DELETE = "Delete"

}

extension OptionMenu: Identifiable {
    var id: RawValue { rawValue }
}

extension OptionMenu: Applicable {
    // TODO pass object that confronts to Handleable protocol
    func apply(_ selected: String) {
        switch self {

        case .EDIT:
            // TODO implement edit functionality here
            // TODO call handle function of passed parameter abject
            print("Print from Enum: EDIT")

        case .DELETE:
            // TODO implement delete functionality here
            print("Print from Enum: DELETE")
        }
    }
}
