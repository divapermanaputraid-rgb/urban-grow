import UserNotifications
import Foundation

final class NotificationService {
    static let shared = NotificationService()

    private init() {
        requestPermission()
    }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func scheduleNotification(for task: ScheduledTask) {
        guard let reminderTime = task.reminderTime, task.taskStatus == .pending || task.taskStatus == .delayed else { return }

        let content = UNMutableNotificationContent()
        content.title = "🌱 UrbanGrow"
        content.body = "Day \(task.plannedDayOffset): \(task.displayTitle) untuk \(task.batch?.label ?? "Batch")"
        content.sound = .default

        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: task.plannedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: reminderTime)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelNotification(for taskId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId.uuidString])
    }

    func rescheduleNotifications(for tasks: [ScheduledTask]) {
        for task in tasks {
            cancelNotification(for: task.id)
            scheduleNotification(for: task)
        }
    }
}
