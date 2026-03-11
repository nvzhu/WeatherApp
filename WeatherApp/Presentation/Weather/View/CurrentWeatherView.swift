import UIKit

final class CurrentWeatherView: UIView {

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 64, weight: .thin)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private let windLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()

    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
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

    func configure(with viewModel: WeatherViewModel) {
        temperatureLabel.text = viewModel.temperature
        conditionLabel.text = viewModel.conditionText
        feelsLikeLabel.text = viewModel.feelsLike
        windLabel.text = "Ветер: \(viewModel.wind)"
        humidityLabel.text = "Влажность: \(viewModel.humidity)"

        if let url = viewModel.iconURL {
            Task {
                iconView.image = await ImageLoader.shared.load(from: url)
            }
        }
    }

    // MARK: - Layout

    private func setupLayout() {
        let detailsStack = UIStackView(arrangedSubviews: [windLabel, humidityLabel])
        detailsStack.spacing = 24
        detailsStack.distribution = .equalSpacing

        let mainStack = UIStackView(arrangedSubviews: [
            temperatureLabel, iconView, conditionLabel, feelsLikeLabel, detailsStack
        ])
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.spacing = 4
        mainStack.setCustomSpacing(8, after: temperatureLabel)
        mainStack.setCustomSpacing(12, after: feelsLikeLabel)

        addSubview(mainStack, with: { stack, parent in
            [
                stack.topAnchor.constraint(equalTo: parent.topAnchor),
                stack.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16),
                stack.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -16),
                stack.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
            ]
        })

        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 64),
            iconView.widthAnchor.constraint(equalToConstant: 64)
        ])
    }
}
