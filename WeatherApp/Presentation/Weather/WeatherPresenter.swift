import Foundation

// MARK: - ViewModel

struct WeatherViewModel {
    let cityName: String
    let temperature: String
    let iconURL: URL?
    let conditionText: String
    let feelsLike: String
    let wind: String
    let humidity: String
    let hourly: [HourlyItem]
    let daily: [DailyItem]

    struct HourlyItem {
        let time: String
        let temperature: String
        let iconURL: URL?
    }

    struct DailyItem {
        let dayName: String
        let iconURL: URL?
        let high: String
        let low: String
    }
}

// MARK: - View Protocol

protocol WeatherViewInput: AnyObject {
    func showLoading()
    func showError(_ message: String)
    func showContent(_ viewModel: WeatherViewModel)
}

// MARK: - Presenter

final class WeatherPresenter {

    weak var view: WeatherViewInput?

    private let weatherService: WeatherService
    private let locationService: LocationService

    init(weatherService: WeatherService, locationService: LocationService) {
        self.weatherService = weatherService
        self.locationService = locationService
    }

    func viewDidLoad() {
        loadWeather()
    }

    func retry() {
        loadWeather()
    }

    // MARK: - Private

    private func loadWeather() {
        view?.showLoading()
        Task {
            do {
                let coords = await locationService.requestLocation()
                let response = try await weatherService.fetchForecast(
                    lat: coords.lat,
                    lon: coords.lon
                )
                view?.showContent(makeViewModel(from: response))
            } catch {
                view?.showError(error.localizedDescription)
            }
        }
    }

    private func makeViewModel(from response: ForecastResponse) -> WeatherViewModel {
        let current = response.current
        return WeatherViewModel(
            cityName: response.location.name,
            temperature: "\(Int(current.tempC))°",
            iconURL: current.condition.iconURL,
            conditionText: current.condition.text,
            feelsLike: "Ощущается как \(Int(current.feelslikeC))°",
            wind: "\(Int(current.windKph)) км/ч",
            humidity: "\(current.humidity)%",
            hourly: makeHourlyItems(from: response.forecast.forecastday),
            daily: makeDailyItems(from: response.forecast.forecastday)
        )
    }

    private func makeHourlyItems(from days: [ForecastDay]) -> [WeatherViewModel.HourlyItem] {
        let currentHour = Calendar.current.component(.hour, from: Date())
        var items: [WeatherViewModel.HourlyItem] = []

        if let today = days.first {
            let remaining = today.hour.filter { extractHour(from: $0.time) >= currentHour }
            items += remaining.map { makeHourlyItem(from: $0) }
        }

        if days.count > 1 {
            items += days[1].hour.map { makeHourlyItem(from: $0) }
        }

        return items
    }

    private func makeHourlyItem(from hour: HourCondition) -> WeatherViewModel.HourlyItem {
        let time = hour.time.split(separator: " ").last.map(String.init) ?? ""
        return .init(time: time, temperature: "\(Int(hour.tempC))°", iconURL: hour.condition.iconURL)
    }

    private func makeDailyItems(from days: [ForecastDay]) -> [WeatherViewModel.DailyItem] {
        days.map { day in
            .init(
                dayName: formatDayName(from: day.date),
                iconURL: day.day.condition.iconURL,
                high: "\(Int(day.day.maxtempC))°",
                low: "\(Int(day.day.mintempC))°"
            )
        }
    }

    private func extractHour(from timeString: String) -> Int {
        let parts = timeString.split(separator: " ")
        guard parts.count == 2 else { return 0 }
        return Int(parts[1].split(separator: ":").first ?? "") ?? 0
    }

    private func formatDayName(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }

        let display = DateFormatter()
        display.locale = Locale(identifier: "ru_RU")
        display.dateFormat = "EEEE"
        let name = display.string(from: date)
        return name.prefix(1).uppercased() + name.dropFirst()
    }
}
