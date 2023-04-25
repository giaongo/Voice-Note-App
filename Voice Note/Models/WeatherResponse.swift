//
//  WeatherResponse.swift
//  Voice Note
//
//  Created by Mohammad Rashid on 23.4.2023.
//

import Foundation

struct WeatherResponse: Codable {
    let current: WeatherCurrent
    enum CodingKeys: String, CodingKey {
        case current = "main"
    }
}

struct WeatherCurrent: Codable {
    let temperature: Double
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}

