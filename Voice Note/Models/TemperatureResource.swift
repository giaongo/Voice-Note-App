// 
// Created by Anwar Ulhaq on 22.4.2023.
// 
// 

import Foundation

/**
    A struct that confronts to APIResource to hold Temperature resource. It holds TemperatureResponse as ModelType,
    A url to resource, methode path and filters as tuple array
*/
struct TemperatureResource: APIResource{
    typealias ModelType = TemperatureResponse
    var resourceURL: String = ""
    var methodPath: String? = ""
    var filters: [(String, String)] = []
}