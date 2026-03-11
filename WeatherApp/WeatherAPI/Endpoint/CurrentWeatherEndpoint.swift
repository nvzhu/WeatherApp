import Foundation

struct CurrentWeatherEndpoint: Endpoint {

    let path = "current.json"
    let queryItems: [URLQueryItem]

    init(lat: Double, lon: Double) {
        queryItems = [
            URLQueryItem(name: "key", value: WeatherAPI.key),
            URLQueryItem(name: "q", value: "\(lat),\(lon)")
        ]
    }
}
