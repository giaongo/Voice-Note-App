// 
// Created by Anwar Ulhaq on 20.4.2023.
// 
// 

import Foundation

// Abstract struct to hold any thing fetched from network
// Item should confront to Decodable protocol
struct APIResponseWrapper<T: Decodable> {
    // Other kind of responses can be added
    let temperatureResponse: [T]?
}

extension APIResponseWrapper: Decodable {
    enum CodingKeys: String, CodingKey {
        case temperatureResponse = "dataseries"
    }
}