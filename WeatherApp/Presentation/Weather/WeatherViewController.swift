import UIKit

final class WeatherViewController: UIViewController {

    private let presenter: WeatherPresenter
    private var currentChild: UIViewController?

    // MARK: - Init

    init(presenter: WeatherPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Погода"

        presenter.view = self
        presenter.viewDidLoad()
    }

    // MARK: - Private

    private func transition(to child: UIViewController) {
        currentChild?.removeChildFromParent()
        addChild(child, to: view)
        currentChild = child
    }
}

// MARK: - WeatherViewInput

extension WeatherViewController: WeatherViewInput {

    func showLoading() {
        transition(to: LoadingViewController())
    }

    func showError(_ message: String) {
        let vc = ErrorViewController(message: message)
        vc.onRetry = { [weak self] in
            self?.presenter.retry()
        }
        transition(to: vc)
    }

    func showContent(_ viewModel: WeatherViewModel) {
        navigationItem.title = viewModel.cityName
        transition(to: WeatherContentViewController(viewModel: viewModel))
    }
}
