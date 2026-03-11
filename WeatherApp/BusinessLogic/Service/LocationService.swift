import CoreLocation

final class LocationService: NSObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()
    private var authContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<(lat: Double, lon: Double), Never>?

    private static let moscow = (lat: 55.7558, lon: 37.6173)

    // MARK: - Init

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    // MARK: - Public

    func requestLocation() async -> (lat: Double, lon: Double) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return await fetchLocation()
        case .notDetermined:
            let status = await withCheckedContinuation { continuation in
                self.authContinuation = continuation
                self.manager.requestWhenInUseAuthorization()
            }
            guard status == .authorizedWhenInUse || status == .authorizedAlways else {
                return Self.moscow
            }
            return await fetchLocation()
        default:
            return Self.moscow
        }
    }

    // MARK: - Private

    private func fetchLocation() async -> (lat: Double, lon: Double) {
        await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
            self.manager.requestLocation()
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus != .notDetermined else { return }
        authContinuation?.resume(returning: manager.authorizationStatus)
        authContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationContinuation?.resume(returning: (
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        ))
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(returning: Self.moscow)
        locationContinuation = nil
    }
}
