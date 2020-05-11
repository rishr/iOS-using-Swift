import Foundation

extension DateFormatter {
    static let display: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

extension Date {
    var display: String {
        DateFormatter.display.string(from: self)
    }
}
