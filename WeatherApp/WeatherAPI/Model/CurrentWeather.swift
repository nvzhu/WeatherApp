import Foundation

struct CurrentWeatherResponse: Decodable, Sendable {
    let location: Location
    let current: CurrentCondition
}

struct Location: Decodable, Sendable {
    let name: String
}

struct CurrentCondition: Decodable, Sendable {
    let tempC: Double
    let feelslikeC: Double
    let condition: WeatherCondition
    let windKph: Double
    let humidity: Int

    private enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case feelslikeC = "feelslike_c"
        case condition
        case windKph = "wind_kph"
        case humidity
    }
}

struct WeatherCondition: Decodable, Sendable {
    let text: String
    let icon: String
    let code: Int

    var iconURL: URL? {
        URL(string: "https:" + icon)
    }
}
