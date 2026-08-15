import SwiftData
import Foundation

@Model
class HarvestLog {
    @Attribute(.unique) var id: UUID
    var date: Date
    var weightGram: Double
    var unit: String
    var quantity: Double
    var marketPrice: Double?
    var note: String

    var batch: Batch?

    @Relationship(deleteRule: .nullify)
    var photo: TaskPhoto?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        weightGram: Double = 0,
        unit: String = "gram",
        quantity: Double = 0,
        marketPrice: Double? = nil,
        note: String = ""
    ) {
        self.id = id
        self.date = date
        self.weightGram = weightGram
        self.unit = unit
        self.quantity = quantity
        self.marketPrice = marketPrice
        self.note = note
    }

    var totalValue: Double? {
        guard let price = marketPrice else { return nil }
        return price * quantity
    }

    var displayQuantity: String {
        if weightGram > 0 {
            return "\(String(format: "%.0f", weightGram))g"
        }
        return "\(String(format: "%.1f", quantity)) \(unit)"
    }
}
