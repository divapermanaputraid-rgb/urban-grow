import SwiftData
import Foundation

@Model
class Plant {
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: String
    var colorHex: String

    @Relationship(deleteRule: .cascade)
    var milestones: [Milestone]?

    var batches: [Batch]?

    init(id: UUID = UUID(), name: String, icon: String, colorHex: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
    }

    var plantType: PlantType? {
        PlantType(rawValue: name)
    }
}
