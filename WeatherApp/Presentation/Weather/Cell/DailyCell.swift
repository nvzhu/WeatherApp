import UIKit

final class DailyCell: UIView {

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let highLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()

    private let lowLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    func configure(with item: WeatherViewModel.DailyItem) {
        dayLabel.text = item.dayName
        highLabel.text = item.high
        lowLabel.text = item.low

        if let url = item.iconURL {
            Task { [weak self] in
                self?.iconView.image = await ImageLoader.shared.load(from: url)
            }
        }
    }

    // MARK: - Layout

    private func setupLayout() {
        let tempStack = UIStackView(arrangedSubviews: [highLabel, lowLabel])
        tempStack.spacing = 8

        let mainStack = UIStackView(arrangedSubviews: [dayLabel, iconView, tempStack])
        mainStack.alignment = .center
        mainStack.spacing = 12

        dayLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        addSubview(mainStack, with: { stack, parent in
            [
                stack.topAnchor.constraint(equalTo: parent.topAnchor, constant: 8),
                stack.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16),
                stack.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -16),
                stack.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -8)
            ]
        })

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),
            highLabel.widthAnchor.constraint(equalToConstant: 36),
            lowLabel.widthAnchor.constraint(equalToConstant: 36)
        ])
    }
}
