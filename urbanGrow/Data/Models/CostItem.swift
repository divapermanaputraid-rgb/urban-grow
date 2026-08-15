import SwiftData
import Foundation

@Model
class CostItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var amount: Double
    var category: String // CostCategory rawValue
    var date: Date
    var lifespanCycles: Int?
    var isShared: Bool

    var batch: Batch?

    init(
        id: UUID = UUID(),
        name: String,
        amount: Double,
        category: CostCategory = .operational,
        date: Date = Date(),
        lifespanCycles: Int? = nil,
        isShared: Bool = false
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.category = category.rawValue
        self.date = date
        self.lifespanCycles = lifespanCycles
        self.isShared = isShared
    }

    var costCategory: CostCategory {
        get { CostCategory(rawValue: category) ?? .other }
        set { category = newValue.rawValue }
    }

    var effectiveCost: Double {
        guard isShared, let lifespan = lifespanCycles, lifespan > 0 else {
            return amount
        }
        return amount / Double(lifespan)
    }
}
