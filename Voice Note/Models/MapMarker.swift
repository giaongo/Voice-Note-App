// 
// Created by Anwar Ulhaq on 28.4.2023.
// 
// 

import Foundation
import CoreLocation

struct MapMarker: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
    let type: AnnotationType
    init(id: UUID, type: AnnotationType, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.type = type
        self.coordinate = coordinate
    }
}
