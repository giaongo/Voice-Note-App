//
//  Place.swift
//  Voice Note
//
//  Created by Darja Polevaja on 9.4.2023.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    
    var id = UUID().uuidString
    var place: MKPlacemark
}
