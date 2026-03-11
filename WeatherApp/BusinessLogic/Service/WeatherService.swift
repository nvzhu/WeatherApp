import Foundation

final class WeatherService {

    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeatherResponse {
        try await client.request(CurrentWeatherEndpoint(lat: lat, lon: lon))
    }

    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastResponse {
        try await client.request(ForecastEndpoint(lat: lat, lon: lon))
    }
}
