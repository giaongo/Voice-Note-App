import Foundation
import CoreData

/**
  A protocol is intended to be used as a blueprint for defining the size in a program
 */
protocol Applicable {
    func apply(_: NSManagedObject)
}
