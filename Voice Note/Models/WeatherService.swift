//
//  WeatherService.swift
//  Voice Note
//
//  Created by Mohammad Rashid on 23.4.2023.
//

import Foundation
import Combine
import CoreLocation

struct WeatherService {
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "c55b372ffdf9f6dcc3f535d009f52246"
    
    func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> AnyPublisher<WeatherResponse, Error> {
        let url = "\(baseUrl)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        print("Request URL: \(url)") // Print request URL
        
        guard let requestUrl = URL(string: url) else {
            fatalError("Invalid URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: requestUrl)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
