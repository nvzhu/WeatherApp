import UIKit

final class WeatherContentViewController: UIViewController {

    private let viewModel: WeatherViewModel

    private let scrollView = UIScrollView()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()

    private let currentWeatherView = CurrentWeatherView()

    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 72, height: 100)
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.reuseID)
        cv.dataSource = self
        return cv
    }()

    // MARK: - Init

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        currentWeatherView.configure(with: viewModel)
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(scrollView, with: { scroll, parent in
            scroll.pin(to: parent.safeAreaLayoutGuide)
        })

        scrollView.addSubview(stackView, with: { stack, parent in
            [
                stack.topAnchor.constraint(equalTo: parent.topAnchor, constant: 16),
                stack.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
                stack.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -16),
                stack.widthAnchor.constraint(equalTo: parent.widthAnchor)
            ]
        })

        stackView.addArrangedSubview(currentWeatherView)
        stackView.addArrangedSubview(makeSectionHeader("Почасовой прогноз"))
        stackView.addArrangedSubview(hourlyCollectionView)
        stackView.addArrangedSubview(makeSectionHeader("Прогноз на 3 дня"))

        hourlyCollectionView.heightAnchor.constraint(equalToConstant: 110).isActive = true

        for item in viewModel.daily {
            let cell = DailyCell()
            cell.configure(with: item)
            stackView.addArrangedSubview(cell)
        }
    }

    private func makeSectionHeader(_ text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label

        let container = UIView()
        container.addSubview(label, with: { label, parent in
            [
                label.topAnchor.constraint(equalTo: parent.topAnchor),
                label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -16),
                label.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
            ]
        })
        return container
    }
}

// MARK: - UICollectionViewDataSource

extension WeatherContentViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.hourly.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyCell.reuseID,
            for: indexPath
        ) as! HourlyCell
        cell.configure(with: viewModel.hourly[indexPath.item])
        return cell
    }
}
