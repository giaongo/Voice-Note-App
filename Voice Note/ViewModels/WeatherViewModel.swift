//
//  WeatherViewModel.swift
//  Voice Note
//
//  Created by Mohammad Rashid on 23.4.2023.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var temperature: Double = 0.0

    private var weatherService: WeatherService
    private var cancellable: AnyCancellable?

    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
    }

    func fetchCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        cancellable = weatherService.getWeather(latitude: latitude, longitude: longitude)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching weather data: \(error)")
                }
            }, receiveValue: { weather in
                self.temperature = weather.current.temperature
            })
    }
}
