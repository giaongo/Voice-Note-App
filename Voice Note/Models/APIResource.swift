// 
// Created by Anwar Ulhaq on 21.4.2023.
// 
// 

import Foundation

/**
    Provides a shared implementation of network resource,
    an associated model type into which data needs to be converted (Temperature, Wind, etc.).
    a resourceURL, for different type of weather api (TemperatureAPI, WindAPI, etc.)
    optional methodPath, e.g. /v2 of /current etc.
    parameters to filter or sort the data in the response;

 */
protocol APIResource {
    associatedtype ModelType: Decodable
    var resourceURL: String { get }
    var methodPath: String? { get }
    var filters: [(String, String)] { get }
}

extension APIResource {
    var url: URL {
        var components = URLComponents(string: resourceURL)!
        components.queryItems = []
        if let methodPath = methodPath {
            components.path = methodPath
        }
        if !filters.isEmpty {
            for (filterName, filterValue) in filters {
                components.queryItems?.append(URLQueryItem(name: filterName, value: filterValue))
            }
        }
        return components.url!
    }
}
