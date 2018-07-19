import Foundation

class CustomDateFormatter {
    static func parseDate(_ date: Date, _ formatter: DateFormatter) -> String {
        formatter.calendar = SettingsManager.sharedInstance.calendar
        return formatter.string(from: date)
    }
    
    static func dateFromString(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        if let date = dateFormatter.date(from: string) {
            return date
        } else {
            return Date()
        }
    }
}
