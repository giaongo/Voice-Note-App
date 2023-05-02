// 
// Created by Anwar Ulhaq on 21.4.2023.
// 
// 

import Foundation

/// A wrapper to hold response from temperature API
/// https://www.7timer.info/bin/api.pl
struct TemperatureResponse: Identifiable {
    let id: Int32
    let weather: String
    let temperature: Temperature
    var windSpeed: Int
}

extension TemperatureResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case weather
        // used date as id
        case id = "date"
        case temperature = "temp2m"
        case windSpeed = "wind10m_max"
    }
}