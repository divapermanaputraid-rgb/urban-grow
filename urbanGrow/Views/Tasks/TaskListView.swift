import SwiftUI

struct TaskListView: View {
    let tasks: [ScheduledTask]
    var onCompleteTask: (ScheduledTask) -> Void
    var onDelayTask: (ScheduledTask) -> Void

    var sortedTasks: [ScheduledTask] {
        tasks.sorted { $0.plannedDayOffset < $1.plannedDayOffset }
    }

    var body: some View {
        if sortedTasks.isEmpty {
            EmptyStateView(
                icon: "checkmark.circle",
                title: "Belum Ada Task",
                message: "Semua task roadmap untuk batch ini akan tampil di sini"
            )
        } else {
            LazyVStack(spacing: 12) {
                ForEach(sortedTasks) { task in
                    TaskRow(
                        task: task,
                        onComplete: { onCompleteTask(task) },
                        onDelayOneDay: { onDelayTask(task) }
                    )
                }
            }
        }
    }
}
