import Foundation

struct ForecastResponse: Decodable, Sendable {
    let location: Location
    let current: CurrentCondition
    let forecast: ForecastData
}

struct ForecastData: Decodable, Sendable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable, Sendable {
    let date: String
    let day: DayCondition
    let hour: [HourCondition]
}

struct DayCondition: Decodable, Sendable {
    let maxtempC: Double
    let mintempC: Double
    let condition: WeatherCondition

    private enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
    }
}

struct HourCondition: Decodable, Sendable {
    let time: String
    let tempC: Double
    let condition: WeatherCondition

    private enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case condition
    }
}
