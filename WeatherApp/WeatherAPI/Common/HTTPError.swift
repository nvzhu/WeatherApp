import Foundation

enum HTTPError: Error {
    case invalidResponse
    case statusCode(Int)
}
