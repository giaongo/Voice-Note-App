// 
// Created by Anwar Ulhaq on 20.4.2023.
// 
// 

import Foundation

// Abstract struct to hold any thing fetched from network
// Item should confront to Decodable protocol
struct Wrapper<T: Decodable>: Decodable {
    let items: [T]
}
