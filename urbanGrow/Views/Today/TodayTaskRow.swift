import SwiftUI

struct TodayTaskRow: View {
    let task: ScheduledTask
    var onComplete: (() -> Void)? = nil
    var onDelayOneDay: (() -> Void)? = nil
    var onSkip: ((String) -> Void)? = nil

    @State private var isShowingSkipAlert: Bool = false
    @State private var skipReason: String = ""

    private var batchLabel: String {
        task.batch?.label ?? "Batch"
    }

    var body: some View {
        HStack(spacing: 12) {
            DayCounterView(day: task.plannedDayOffset, isOverdue: task.isOverdue)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.displayTitle)
                    .font(.body.bold())
                Text(batchLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if let deviation = task.deviationText {
                    Text(deviation)
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }

            Spacer()

            StatusBadge(status: task.taskStatus)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3)
        .swipeActions(edge: .leading) {
            if task.taskStatus == .pending || task.taskStatus == .delayed {
                Button {
                    onComplete?()
                } label: {
                    Label("Selesai", systemImage: "checkmark")
                }
                .tint(.green)
            }
        }
        .swipeActions(edge: .trailing) {
            if task.taskStatus == .pending || task.taskStatus == .delayed {
                Button {
                    onDelayOneDay?()
                } label: {
                    Label("Tunda 1 Hari", systemImage: "clock.arrow.circlepath")
                }
                .tint(.orange)
            }
        }
        .contextMenu {
            if task.taskStatus == .pending || task.taskStatus == .delayed {
                Button(role: .destructive) {
                    isShowingSkipAlert = true
                } label: {
                    Label("Lewati Task", systemImage: "forward.end")
                }
            }
        }
        .alert("Lewati Task", isPresented: $isShowingSkipAlert) {
            TextField("Alasan (opsional)", text: $skipReason)
            Button("Batal", role: .cancel) { skipReason = "" }
            Button("Lewati", role: .destructive) {
                onSkip?(skipReason)
                skipReason = ""
            }
        } message: {
            Text("Apakah kamu yakin ingin melewati task ini?")
        }
    }
}
