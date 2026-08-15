import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScheduledTask.plannedDate, order: .forward) private var allTasks: [ScheduledTask]
    @Environment(AppState.self) private var appState

    @State private var selectedTaskToComplete: ScheduledTask?
    @State private var isShowingSettings: Bool = false

    private var startOfToday: Date {
        Calendar.current.startOfDay(for: Date())
    }

    private var overdueTasks: [ScheduledTask] {
        allTasks.filter { task in
            (task.taskStatus == .pending || task.taskStatus == .delayed) &&
            task.plannedDate < startOfToday
        }
    }

    private var todayTasks: [ScheduledTask] {
        allTasks.filter { task in
            (task.taskStatus == .pending || task.taskStatus == .delayed) &&
            Calendar.current.isDate(task.plannedDate, inSameDayAs: Date())
        }
    }

    private var upcomingTasks: [ScheduledTask] {
        let threeDaysLater = Calendar.current.date(byAdding: .day, value: 3, to: startOfToday) ?? Date()
        return allTasks.filter { task in
            (task.taskStatus == .pending || task.taskStatus == .delayed) &&
            task.plannedDate > startOfToday &&
            task.plannedDate <= threeDaysLater &&
            !Calendar.current.isDate(task.plannedDate, inSameDayAs: Date())
        }
    }

    private var isEmpty: Bool {
        overdueTasks.isEmpty && todayTasks.isEmpty && upcomingTasks.isEmpty
    }

    var body: some View {
        VStack {
            if isEmpty {
                EmptyStateView(
                    icon: "sun.max",
                    title: "Tidak ada aktivitas hari ini",
                    message: "Semua task sudah selesai. 🌱"
                )
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if !overdueTasks.isEmpty {
                            Section(header: sectionHeader("Terlewat (\(overdueTasks.count))", color: .orange)) {
                                ForEach(overdueTasks) { task in
                                    taskRowWithNavigation(task)
                                }
                            }
                        }

                        if !todayTasks.isEmpty {
                            Section(header: sectionHeader("Hari Ini (\(todayTasks.count))", color: .primary)) {
                                ForEach(todayTasks) { task in
                                    taskRowWithNavigation(task)
                                }
                            }
                        }

                        if !upcomingTasks.isEmpty {
                            Section(header: sectionHeader("Mendatang (3 Hari)", color: .secondary)) {
                                ForEach(upcomingTasks) { task in
                                    taskRowWithNavigation(task)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
                .refreshable {
                    // SwiftData auto-updates, refreshable provides native feel
                }
            }
        }
        .navigationTitle("Hari Ini")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isShowingSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .navigationDestination(for: Batch.self) { batch in
            BatchDetailView(batch: batch)
        }
        .sheet(item: $selectedTaskToComplete) { task in
            CompleteTaskSheet(task: task)
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView()
        }
    }

    @ViewBuilder
    private func taskRowWithNavigation(_ task: ScheduledTask) -> some View {
        if let batch = task.batch {
            NavigationLink(value: batch) {
                TodayTaskRow(
                    task: task,
                    onComplete: { selectedTaskToComplete = task },
                    onDelayOneDay: { delayTaskOneDay(task) },
                    onSkip: { reason in skipTask(task, reason: reason) }
                )
            }
            .buttonStyle(.plain)
        } else {
            TodayTaskRow(
                task: task,
                onComplete: { selectedTaskToComplete = task },
                onDelayOneDay: { delayTaskOneDay(task) },
                onSkip: { reason in skipTask(task, reason: reason) }
            )
        }
    }

    private func sectionHeader(_ title: String, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(color)
            Spacer()
        }
        .padding(.top, 8)
    }

    private func delayTaskOneDay(_ task: ScheduledTask) {
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: task.plannedDate) ?? task.plannedDate
        CascadeRescheduleService.shared.rescheduleTask(task, to: newDate, in: modelContext)
    }

    private func skipTask(_ task: ScheduledTask, reason: String) {
        task.taskStatus = .skipped
        if !reason.isEmpty {
            task.note = reason
        }
        NotificationService.shared.cancelNotification(for: task.id)
        try? modelContext.save()
    }
}
