import Foundation

final class NetworkClient {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func request<T: Decodable>(_ endpoint: some Endpoint) async throws -> T {
        let (data, response) = try await session.data(from: endpoint.url)

        guard let http = response as? HTTPURLResponse else {
            throw HTTPError.invalidResponse
        }
        guard 200..<300 ~= http.statusCode else {
            throw HTTPError.statusCode(http.statusCode)
        }

        return try decoder.decode(T.self, from: data)
    }
}
