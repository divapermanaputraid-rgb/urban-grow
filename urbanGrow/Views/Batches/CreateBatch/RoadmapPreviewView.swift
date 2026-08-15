import SwiftUI

struct RoadmapPreviewView: View {
    let plant: Plant?
    let startDate: Date
    var onCreate: () -> Void
    var onBack: () -> Void

    var sortedMilestones: [Milestone] {
        (plant?.milestones ?? []).sorted { $0.dayOffset < $1.dayOffset }
    }

    var body: some View {
        VStack {
            List {
                Section("Preview Jadwal / Task Roadmap") {
                    ForEach(sortedMilestones, id: \.id) { milestone in
                        let estimatedDate = Calendar.current.date(byAdding: .day, value: milestone.dayOffset, to: startDate) ?? startDate

                        HStack(spacing: 12) {
                            DayCounterView(day: milestone.dayOffset)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(milestone.title)
                                    .font(.subheadline.bold())
                                if !milestone.desc.isEmpty {
                                    Text(milestone.desc)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                            }

                            Spacer()

                            Text(estimatedDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            HStack {
                Button("Kembali", action: onBack)
                    .buttonStyle(.bordered)
                Spacer()
                Button("Buat Batch", action: onCreate)
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
            }
            .padding()
        }
    }
}
