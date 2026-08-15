import Foundation

enum CurrencyFormatter {
    private static let formatter: NumberFormatter = {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.locale = Locale(identifier: "id_ID")
        fmt.maximumFractionDigits = 0
        return fmt
    }()

    static func format(_ value: Double) -> String {
        return formatter.string(from: NSNumber(value: value)) ?? "Rp \(Int(value))"
    }
}
