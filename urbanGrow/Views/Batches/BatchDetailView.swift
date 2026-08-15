import SwiftUI
import SwiftData

struct BatchDetailView: View {
    @Bindable var batch: Batch
    @State private var selectedTab: DetailSegment = .roadmap

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
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Roadmap Timeline")
                                .font(.headline)
                            if let tasks = batch.tasks, !tasks.isEmpty {
                                Text("\(tasks.count) Task Terjadwal")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Belum ada task")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
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
    }
}
