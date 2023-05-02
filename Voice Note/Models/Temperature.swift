import Foundation
import CoreData


/**
 A CoreData entity class extension to make it confront to decodable
  */
@objc(Temperature)
public class Temperature: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case minimum = "min"
        case maximum = "max"
    }
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        maximum = try container.decode(Int32.self, forKey: .maximum)
        minimum = try container.decode(Int32.self, forKey: .minimum)
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

// TODO move it some where else
enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}
