import SwiftUI
import MapKit

/**
    A Model that defines search places
 */
struct Place: Identifiable {
    
    var id = UUID().uuidString
    var place: MKPlacemark
    var tags: String
}
