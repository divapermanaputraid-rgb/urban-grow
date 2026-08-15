import SwiftData
import Foundation

@Model
class Milestone {
    var id: UUID
    var dayOffset: Int
    var title: String
    var desc: String
    var isSlideable: Bool
    var reminderTime: Date?
    var order: Int

    var plant: Plant?
    var scheduledTasks: [ScheduledTask]?

    init(
        id: UUID = UUID(),
        dayOffset: Int,
        title: String,
        desc: String = "",
        isSlideable: Bool = true,
        reminderTime: Date? = nil,
        order: Int = 0
    ) {
        self.id = id
        self.dayOffset = dayOffset
        self.title = title
        self.desc = desc
        self.isSlideable = isSlideable
        self.reminderTime = reminderTime
        self.order = order
    }
}
