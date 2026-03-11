import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let services = ServiceLayer.shared
        let presenter = WeatherPresenter(
            weatherService: services.weatherService,
            locationService: services.locationService
        )
        let weatherVC = WeatherViewController(presenter: presenter)

        let nav = UINavigationController(rootViewController: weatherVC)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
}
