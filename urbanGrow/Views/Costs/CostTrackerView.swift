import SwiftUI
import SwiftData

struct CostTrackerView: View {
    @Query(sort: \CostItem.date, order: .reverse) private var costItems: [CostItem]
    @Query private var batches: [Batch]

    @State private var isShowingAddCostSheet: Bool = false

    private var totalCostAll: Double {
        costItems.reduce(0) { $0 + $1.effectiveCost }
    }

    private var currentMonthCost: Double {
        let now = Date()
        let calendar = Calendar.current
        return costItems.filter { item in
            calendar.isDate(item.date, equalTo: now, toGranularity: .month)
        }.reduce(0) { $0 + $1.effectiveCost }
    }

    private var infrastructureCosts: [CostItem] {
        costItems.filter { $0.isShared }
    }

    var body: some View {
        VStack(spacing: 0) {
            if costItems.isEmpty {
                EmptyStateView(
                    icon: "dollarsign.circle",
                    title: "Belum Ada Catatan Modal",
                    message: "Catat pengeluaran bibit, tanah, pupuk, dan infrastrukturmu",
                    actionTitle: "+ Tambah Modal",
                    action: { isShowingAddCostSheet = true }
                )
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // Summary Cards
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Bulan Ini")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(CurrencyFormatter.format(currentMonthCost))
                                    .font(.title3.bold())
                                    .foregroundStyle(.primary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.04), radius: 3)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total Pengeluaran")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(CurrencyFormatter.format(totalCostAll))
                                    .font(.title3.bold())
                                    .foregroundStyle(.green)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.04), radius: 3)
                        }

                        // ROI per Batch Section
                        if !batches.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Analisis Modal & ROI per Batch")
                                    .font(.headline)

                                ForEach(batches) { batch in
                                    NavigationLink(destination: ROIDetailView(batch: batch)) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(batch.label)
                                                    .font(.subheadline.bold())
                                                    .foregroundStyle(.primary)
                                                Text(batch.plant?.name ?? "Tanaman")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }

                                            Spacer()

                                            VStack(alignment: .trailing, spacing: 2) {
                                                Text(CurrencyFormatter.format(batch.totalCost))
                                                    .font(.subheadline.bold())
                                                    .foregroundStyle(.primary)
                                                Text("Panen: \(CurrencyFormatter.format(batch.totalHarvestValue))")
                                                    .font(.caption)
                                                    .foregroundStyle(.green)
                                            }

                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        .padding()
                                        .background(Color(.systemBackground))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }

                        // Infrastructure Section
                        if !infrastructureCosts.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Infrastruktur (Biaya Terbagi)")
                                    .font(.headline)

                                ForEach(infrastructureCosts) { item in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.name)
                                                .font(.subheadline.bold())
                                            Text("Umur pakai: \(item.lifespanCycles ?? 1) siklus")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text("\(CurrencyFormatter.format(item.effectiveCost))/siklus")
                                                .font(.subheadline.bold())
                                            Text("Total: \(CurrencyFormatter.format(item.amount))")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(10)
                                }
                            }
                        }

                        // Recent Costs List
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Semua Pengeluaran")
                                .font(.headline)

                            ForEach(costItems) { item in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.name)
                                            .font(.subheadline.bold())
                                        Text("\(item.costCategory.rawValue) • \(item.date.formatted(date: .abbreviated, time: .omitted))")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(CurrencyFormatter.format(item.amount))
                                        .font(.subheadline.bold())
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle("Modal")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isShowingAddCostSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isShowingAddCostSheet) {
            CostInputView()
        }
    }
}
