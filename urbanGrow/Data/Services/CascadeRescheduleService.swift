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

        guard let batchId = task.batch?.id else {
            try context.save()
            return
        }

        let predicate = #Predicate<ScheduledTask> { taskInBatch in
            taskInBatch.batch?.id == batchId &&
            taskInBatch.plannedDate > originalPlanned &&
            taskInBatch.id != task.id
        }
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.plannedDate)])
        let subsequentTasks = try context.fetch(descriptor)

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
