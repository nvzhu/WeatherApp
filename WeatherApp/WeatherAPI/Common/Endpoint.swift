import Foundation

enum WeatherAPI {
    static let key = "fa8b3df74d4042b9aa7135114252304"
    static let baseURL = "https://api.weatherapi.com/v1"
}

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var url: URL {
        var components = URLComponents(string: WeatherAPI.baseURL + "/" + path)!
        components.queryItems = queryItems
        return components.url!
    }
}
