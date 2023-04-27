import SwiftUI
import MapKit

/**
    A Model defines location information on map
 */
struct Place: Identifiable {
    
    var id = UUID().uuidString
    var place: CLPlacemark
}
