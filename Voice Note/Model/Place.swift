//
//  Place.swift
//  Voice Note
//
//  Created by iosdev on 4.4.2023.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    
    var id = UUID().uuidString
    var place: CLPlacemark
}
