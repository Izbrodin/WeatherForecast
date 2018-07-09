import Foundation

class CustomDateFormatter {
    static func parseDate(_ date: Date, _ formatter: DateFormatter) -> String {
        formatter.calendar = SettingsManager.sharedInstance.calendar
        return formatter.string(from: date)
    }
}
