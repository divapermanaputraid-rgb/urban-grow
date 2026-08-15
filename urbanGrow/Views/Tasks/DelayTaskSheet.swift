import SwiftUI
import SwiftData

struct DelayTaskSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let task: ScheduledTask

    @State private var delayDays: Int = 1

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Tunda Task")
                        .font(.title2.bold())
                    Text(task.displayTitle)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top)

                VStack(spacing: 16) {
                    Stepper("Tunda \(delayDays) hari", value: $delayDays, in: 1...14)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)

                    HStack(spacing: 8) {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.orange)
                        Text("Semua task berikutnya dalam batch ini yang bersifat fleksibel akan otomatis ikut bergeser \(delayDays) hari.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                }

                Spacer()

                Button("Konfirmasi Tunda") {
                    confirmDelay()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .frame(maxWidth: .infinity)
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
            }
        }
        .presentationDetents([.height(300)])
    }

    private func confirmDelay() {
        let newDate = Calendar.current.date(byAdding: .day, value: delayDays, to: task.plannedDate) ?? task.plannedDate
        CascadeRescheduleService.shared.rescheduleTask(task, to: newDate, in: modelContext)
        dismiss()
    }
}
