import UIKit

final class LoadingViewController: UIViewController {

    private let indicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(indicator, with: { indicator, parent in
            [
                indicator.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: parent.centerYAnchor)
            ]
        })

        indicator.startAnimating()
    }
}
