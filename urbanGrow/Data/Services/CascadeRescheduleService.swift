import SwiftData
import Foundation

final class CascadeRescheduleService {
    static let shared = CascadeRescheduleService()

    private init() {}

    func rescheduleTask(_ task: ScheduledTask, to newDate: Date, in context: ModelContext) throws {
        let calendar = Calendar.current
        let originalPlanned = task.plannedDate
        let delayDays = calendar.dateComponents([.day], from: originalPlanned, to: newDate).day ?? 0

        guard delayDays > 0 else { return }

        task.plannedDate = newDate
        task.plannedDayOffset += delayDays
        task.taskStatus = .delayed
        task.delayDays = delayDays
        task.isCascading = true

        let batchTasks = task.batch?.tasks ?? []
        let subsequentTasks = batchTasks
            .filter { $0.plannedDate > originalPlanned && $0.id != task.id }
            .sorted { $0.plannedDate < $1.plannedDate }

        var affectedTasks: [ScheduledTask] = [task]

        for subsequentTask in subsequentTasks {
            if subsequentTask.milestone?.isSlideable ?? true {
                if let newPlannedDate = calendar.date(byAdding: .day, value: delayDays, to: subsequentTask.plannedDate) {
                    subsequentTask.plannedDate = newPlannedDate
                    subsequentTask.plannedDayOffset += delayDays
                    affectedTasks.append(subsequentTask)
                }
            }
        }

        try context.save()

        NotificationService.shared.rescheduleNotifications(for: affectedTasks)
    }
}
