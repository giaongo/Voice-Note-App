// 
// Created by Anwar Ulhaq on 22.4.2023.
// 
// 

import Foundation

struct TemperatureResource: APIResource{
    typealias ModelType = TemperatureResponse
    var resourceURL: String = ""
    var methodPath: String? = ""
    var filters: [(String, String)] = []
}