import UIKit

final class HourlyCell: UICollectionViewCell {

    static let reuseID = "HourlyCell"

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private var imageTask: Task<Void, Never>?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    func configure(with item: WeatherViewModel.HourlyItem) {
        timeLabel.text = item.time
        tempLabel.text = item.temperature
        imageTask?.cancel()
        iconView.image = nil

        guard let url = item.iconURL else { return }
        imageTask = Task { [weak self] in
            let image = await ImageLoader.shared.load(from: url)
            guard !Task.isCancelled else { return }
            self?.iconView.image = image
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        iconView.image = nil
    }

    // MARK: - Layout

    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [timeLabel, iconView, tempLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4

        contentView.addSubview(stack, with: { stack, parent in
            stack.pin(to: parent, insets: UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4))
        })

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}
