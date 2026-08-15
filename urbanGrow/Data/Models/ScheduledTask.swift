import SwiftData
import Foundation

@Model
class ScheduledTask {
    @Attribute(.unique) var id: UUID
    var plannedDayOffset: Int
    var plannedDate: Date
    var reminderTime: Date?
    var status: String // TaskStatus rawValue
    var completedDate: Date?
    var note: String
    var delayDays: Int
    var isCascading: Bool

    var batch: Batch?
    var milestone: Milestone?

    @Relationship(deleteRule: .nullify)
    var photos: [TaskPhoto]?

    init(
        id: UUID = UUID(),
        plannedDayOffset: Int,
        plannedDate: Date,
        reminderTime: Date? = nil,
        status: TaskStatus = .pending,
        note: String = "",
        delayDays: Int = 0,
        isCascading: Bool = false
    ) {
        self.id = id
        self.plannedDayOffset = plannedDayOffset
        self.plannedDate = plannedDate
        self.reminderTime = reminderTime
        self.status = status.rawValue
        self.note = note
        self.delayDays = delayDays
        self.isCascading = isCascading
    }

    var taskStatus: TaskStatus {
        get { TaskStatus(rawValue: status) ?? .pending }
        set { status = newValue.rawValue }
    }

    var isOverdue: Bool {
        guard taskStatus == .pending else { return false }
        return plannedDate < Calendar.current.startOfDay(for: Date())
    }

    var displayTitle: String {
        milestone?.title ?? "Aktivitas"
    }

    var displayDescription: String {
        milestone?.desc ?? ""
    }

    var deviationText: String? {
        if let completed = completedDate {
            let diff = Calendar.current.dateComponents([.day], from: plannedDate, to: completed).day ?? 0
            if diff > 0 { return "+\(diff) hari" }
            else if diff < 0 { return "\(diff) hari" }
            return nil
        }
        if delayDays > 0 { return "+\(delayDays) hari (tertunda)" }
        return nil
    }
}
