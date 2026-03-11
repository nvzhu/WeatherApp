import UIKit

final class ErrorViewController: UIViewController {

    var onRetry: (() -> Void)?

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    private let retryButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Повторить"
        return UIButton(configuration: config)
    }()

    // MARK: - Init

    init(message: String) {
        super.init(nibName: nil, bundle: nil)
        messageLabel.text = message
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let stack = UIStackView(arrangedSubviews: [messageLabel, retryButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center

        view.addSubview(stack, with: { stack, parent in
            [
                stack.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                stack.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
                stack.leadingAnchor.constraint(greaterThanOrEqualTo: parent.leadingAnchor, constant: 32),
                stack.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor, constant: -32)
            ]
        })

        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }

    @objc private func retryTapped() {
        onRetry?()
    }
}
