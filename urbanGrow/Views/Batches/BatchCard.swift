import SwiftUI

struct BatchCard: View {
    let batch: Batch

    private var plantColor: Color {
        if let hex = batch.plant?.colorHex {
            return Color(hex: hex)
        }
        return .green
    }

    private var progressPercentage: Double {
        guard let tasks = batch.tasks, !tasks.isEmpty else { return 0 }
        let completed = tasks.filter { $0.taskStatus == .completed }.count
        return Double(completed) / Double(tasks.count)
    }

    private var nextTaskTitle: String {
        guard let tasks = batch.tasks else { return "-" }
        let pending = tasks.filter { $0.taskStatus == .pending || $0.taskStatus == .delayed }
            .sorted { $0.plannedDate < $1.plannedDate }
        return pending.first?.displayTitle ?? "Selesai"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let icon = batch.plant?.icon {
                    Image(systemName: icon)
                        .foregroundStyle(plantColor)
                }
                Text(batch.label)
                    .font(.headline)
                Spacer()
                StatusBadge(status: batch.batchStatus)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(plantColor)
                        .frame(width: max(0, geo.size.width * progressPercentage))
                }
            }
            .frame(height: 8)

            HStack {
                Text("Umur: \(batch.ageInDays) hari")
                Spacer()
                Text("Next: \(nextTaskTitle)")
                    .lineLimit(1)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}
