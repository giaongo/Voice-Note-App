// 
// Created by Anwar Ulhaq on 28.4.2023.
// 
// 

import Foundation
import CoreLocation

/**
    A Identifiable struct whose instance holds a visible marker on Map
 */
struct MapMarker: Identifiable {
    let id: UUID
    let taggedText: String
    let coordinate: CLLocationCoordinate2D
    let type: AnnotationType
    init(id: UUID, taggedText: String, type: AnnotationType, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.taggedText = taggedText
        self.type = type
        self.coordinate = coordinate
    }
}
