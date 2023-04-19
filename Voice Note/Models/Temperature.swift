//
//  Temperature.swift
//  Voice Note
//
//  Created by Anwar Ulhaq on 19.4.2023.
//

import Foundation
import CoreData

@objc(Temperature)
public class Temperature: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
            case average
            case minimum = "min"
            case maximum = "max"
        }
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        average = try container.decode(Int32.self, forKey: .average)
        maximum = try container.decode(Int32.self, forKey: .maximum)
        minimum = try container.decode(Int32.self, forKey: .minimum)
    }
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}
