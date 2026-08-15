import SwiftUI
import SwiftData

struct BatchDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var batch: Batch
    @State private var selectedTab: DetailSegment = .roadmap
    @State private var selectedTaskToComplete: ScheduledTask?

    enum DetailSegment: String, CaseIterable, Identifiable {
        case roadmap = "Roadmap"
        case photos = "Foto"
        case costs = "Modal"
        case harvest = "Panen"

        var id: String { rawValue }
    }

    private var plantColor: Color {
        if let hex = batch.plant?.colorHex {
            return Color(hex: hex)
        }
        return .green
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header Card
                VStack(spacing: 12) {
                    HStack(spacing: 16) {
                        if let icon = batch.plant?.icon {
                            Image(systemName: icon)
                                .font(.system(size: 36))
                                .foregroundStyle(plantColor)
                                .frame(width: 60, height: 60)
                                .background(plantColor.opacity(0.15))
                                .clipShape(Circle())
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(batch.label)
                                    .font(.title2.bold())
                                Spacer()
                                StatusBadge(status: batch.batchStatus)
                            }

                            Text(batch.plant?.name ?? "Tanaman")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Divider()

                    // Quick Stats & Day Counter
                    HStack {
                        DayCounterView(day: batch.ageInDays)

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Total Modal: \(CurrencyFormatter.format(batch.totalCost))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Total Panen: \(CurrencyFormatter.format(batch.totalHarvestValue))")
                                .font(.caption.bold())
                                .foregroundStyle(.green)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 4)
                .padding(.horizontal)

                // Segmented Control
                Picker("Detail View", selection: $selectedTab) {
                    ForEach(DetailSegment.allCases) { seg in
                        Text(seg.rawValue).tag(seg)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Segment Content Placeholders (Akan diisi di step selanjutnya)
                Group {
                    switch selectedTab {
                    case .roadmap:
                        TaskListView(
                            tasks: batch.tasks ?? [],
                            onCompleteTask: { task in
                                selectedTaskToComplete = task
                            },
                            onDelayTask: { task in
                                delayTaskOneDay(task)
                            }
                        )
                    case .photos:
                        EmptyStateView(icon: "photo.on.rectangle", title: "Galeri Foto", message: "Foto dokumentasi task akan tampil di sini")
                    case .costs:
                        EmptyStateView(icon: "dollarsign.circle", title: "Catatan Modal", message: "Item biaya dan infrastruktur untuk batch ini")
                    case .harvest:
                        EmptyStateView(icon: "basket", title: "Catatan Panen", message: "Hasil dan nilai panen batch ini")
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(batch.label)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedTaskToComplete) { task in
            CompleteTaskSheet(task: task)
        }
    }

    private func delayTaskOneDay(_ task: ScheduledTask) {
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: task.plannedDate) ?? task.plannedDate
        CascadeRescheduleService.shared.rescheduleTask(task, to: newDate, in: modelContext)
    }
}
