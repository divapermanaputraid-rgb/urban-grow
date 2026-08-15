import WeatherKit
import CoreLocation
import Foundation

final class WeatherService {
    static let shared = WeatherService()
    private let weatherService = WeatherKit.WeatherService.shared

    private init() {}

    func fetchCurrentCondition(for location: CLLocation) async -> String? {
        do {
            let weather = try await weatherService.weather(for: location)
            return weather.currentWeather.condition.description
        } catch {
            return nil
        }
    }
}
