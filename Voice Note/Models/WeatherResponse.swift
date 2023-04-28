import Foundation

/**
    A Model defines property that is mapped from JSON key "main"
 */
struct WeatherResponse: Codable {
    let current: WeatherCurrent
    enum CodingKeys: String, CodingKey {
        case current = "main"
    }
}

/**
    A Model defines property that is mapped from JSON key "temp"
 */
struct WeatherCurrent: Codable {
    let temperature: Double
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}

