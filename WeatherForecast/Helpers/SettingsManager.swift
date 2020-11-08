import Foundation

class SettingsManager {

    private init() {
    }

    static let sharedInstance = SettingsManager()

    var cityName = "Penza"
    var locale: Locale = Locale(identifier: "ru_RU")
    var calendar: Calendar = Calendar(identifier: .gregorian)
    var dateFormat = "E, d MMM"
    var dateAndTimeFormat = "E, d MMM yyyy HH:mm"
    var timeFormat = "HH:mm"
    //helps to avoid time offset if local time zone is GMT+
    let timeZone = TimeZone(secondsFromGMT: 0)!

    let baseUrlCurrentWeather = URLBuilder()
        .set(scheme: "http")
        .set(host: "api.openweathermap.org")
        .set(path: "data/2.5/weather")

    let baseUrlForecast5Days = URLBuilder()
        .set(scheme: "http")
        .set(host: "api.openweathermap.org")
        .set(path: "data/2.5/forecast")

    let apiIconBaseUrl = "http://openweathermap.org/img/w/"
    let apiIconExtension = ".png"

    var languageIndex = "ru"
    var units = "metric"
    let appId = "04fe9bc8bdd23ab05caa33af5b162552"
}
