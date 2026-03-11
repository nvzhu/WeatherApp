import Foundation

final class ServiceLayer {

    static let shared = ServiceLayer()

    let weatherService: WeatherService
    let locationService: LocationService

    private init() {
        let client = NetworkClient()
        weatherService = WeatherService(client: client)
        locationService = LocationService()
    }
}
