// 
// Created by Anwar Ulhaq on 28.4.2023.
// 
// 

import Foundation
/**
 A type that provides filters for search
 */
enum SearchFilterItem: String, CaseIterable {
    case BY_VOICE_NOTE = "Voice notes"
    case BY_PLACES = "Places"
}

extension SearchFilterItem: Identifiable {
    var id: RawValue { rawValue }
}