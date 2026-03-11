import UIKit

final class ImageLoader {

    static let shared = ImageLoader()

    private let cache = URLCache(
        memoryCapacity: 50_000_000,
        diskCapacity: 100_000_000
    )
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        session = URLSession(configuration: config)
    }

    func load(from url: URL) async -> UIImage? {
        let request = URLRequest(url: url)

        if let cached = cache.cachedResponse(for: request) {
            return UIImage(data: cached.data)
        }

        guard let (data, response) = try? await session.data(for: request) else { return nil }

        let cachedResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedResponse, for: request)

        return UIImage(data: data)
    }
}
