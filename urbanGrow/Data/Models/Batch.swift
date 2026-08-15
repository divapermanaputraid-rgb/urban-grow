import SwiftData
import Foundation

@Model
class Batch: Hashable {
    @Attribute(.unique) var id: UUID
    var label: String
    var startDate: Date
    var status: String // BatchStatus rawValue

    var plant: Plant?

    @Relationship(deleteRule: .cascade)
    var tasks: [ScheduledTask]?

    @Relationship(deleteRule: .cascade)
    var costs: [CostItem]?

    @Relationship(deleteRule: .cascade)
    var harvestLogs: [HarvestLog]?

    init(
        id: UUID = UUID(),
        label: String,
        startDate: Date,
        status: BatchStatus = .growing
    ) {
        self.id = id
        self.label = label
        self.startDate = startDate
        self.status = status.rawValue
    }

    static func == (lhs: Batch, rhs: Batch) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var batchStatus: BatchStatus {
        get { BatchStatus(rawValue: status) ?? .growing }
        set { status = newValue.rawValue }
    }

    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
    }

    var totalCost: Double {
        (costs ?? []).reduce(0) { $0 + $1.effectiveCost }
    }

    var totalHarvestValue: Double {
        (harvestLogs ?? []).reduce(0) { $0 + ($1.totalValue ?? 0) }
    }

    var isHarvested: Bool {
        batchStatus == .harvested || batchStatus == .archived
    }
}
