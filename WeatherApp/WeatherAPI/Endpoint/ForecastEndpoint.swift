import Foundation

struct ForecastEndpoint: Endpoint {

    let path = "forecast.json"
    let queryItems: [URLQueryItem]

    init(lat: Double, lon: Double, days: Int = 3) {
        queryItems = [
            URLQueryItem(name: "key", value: WeatherAPI.key),
            URLQueryItem(name: "q", value: "\(lat),\(lon)"),
            URLQueryItem(name: "days", value: "\(days)")
        ]
    }
}
