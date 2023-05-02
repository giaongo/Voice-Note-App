import Foundation
import CoreData

/**
  A type that can apply
 */
protocol Applicable {
    func apply(_: NSManagedObject)
}
