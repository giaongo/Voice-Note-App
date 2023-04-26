import Foundation
import Combine
import CoreLocation

/**
    A ViewModel that does API request for weather service 
 */
class WeatherViewModel: ObservableObject {
    @Published var temperature: Double = 0.0

    private var weatherService: WeatherService
    private var cancellable: AnyCancellable?

    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
    }

    func fetchCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        print("Latitude: \(latitude), Longitude: \(longitude)") // Print latitude and longitude
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
