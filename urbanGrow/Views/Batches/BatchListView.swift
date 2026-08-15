import SwiftUI
import SwiftData

struct BatchListView: View {
    @Query(sort: \Batch.startDate, order: .reverse) private var batches: [Batch]
    @Environment(AppState.self) private var appState
    @State private var filterPlant: String = "Semua"
    @State private var isShowingCreateSheet: Bool = false

    private var filterOptions: [String] {
        ["Semua"] + PlantType.allCases.map { $0.rawValue }
    }

    private var filteredBatches: [Batch] {
        if filterPlant == "Semua" {
            return batches
        }
        return batches.filter { $0.plant?.name == filterPlant }
    }

    private var growingBatches: [Batch] {
        filteredBatches.filter { $0.batchStatus == .growing }
    }

    private var harvestedBatches: [Batch] {
        filteredBatches.filter { $0.batchStatus == .harvested }
    }

    private var archivedBatches: [Batch] {
        filteredBatches.filter { $0.batchStatus == .archived }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Filter Segmented Control
            Picker("Filter Plant", selection: $filterPlant) {
                ForEach(filterOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            if filteredBatches.isEmpty {
                EmptyStateView(
                    icon: "square.grid.2x2",
                    title: "Belum Ada Batch",
                    message: "Mulai menanam urban farming pertamamu!",
                    actionTitle: "+ Buat Batch Baru",
                    action: { isShowingCreateSheet = true }
                )
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if !growingBatches.isEmpty {
                            Section(header: headerView("Sedang Tumbuh (\(growingBatches.count))")) {
                                ForEach(growingBatches) { batch in
                                    BatchCard(batch: batch)
                                }
                            }
                        }

                        if !harvestedBatches.isEmpty {
                            Section(header: headerView("Sudah Panen (\(harvestedBatches.count))")) {
                                ForEach(harvestedBatches) { batch in
                                    BatchCard(batch: batch)
                                }
                            }
                        }

                        if !archivedBatches.isEmpty {
                            Section(header: headerView("Arsip (\(archivedBatches.count))")) {
                                ForEach(archivedBatches) { batch in
                                    BatchCard(batch: batch)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle("Batch")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isShowingCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isShowingCreateSheet) {
            CreateBatchView()
        }
    }

    private func headerView(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.top, 8)
    }
}
