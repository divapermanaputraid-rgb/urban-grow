import SwiftUI
import SwiftData

struct ROIDetailView: View {
    let batch: Batch

    var totalCost: Double {
        batch.totalCost
    }

    var totalHarvestValue: Double {
        batch.totalHarvestValue
    }

    var netProfit: Double {
        totalHarvestValue - totalCost
    }

    var roiPercentage: Double {
        guard totalCost > 0 else { return 0 }
        return (netProfit / totalCost) * 100
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Summary Card
                VStack(spacing: 12) {
                    Text(batch.label)
                        .font(.headline)

                    HStack(spacing: 20) {
                        VStack {
                            Text("Total Modal")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(CurrencyFormatter.format(totalCost))
                                .font(.subheadline.bold())
                        }
                        Divider().frame(height: 30)
                        VStack {
                            Text("Hasil Panen")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(CurrencyFormatter.format(totalHarvestValue))
                                .font(.subheadline.bold())
                                .foregroundStyle(.green)
                        }
                    }

                    Divider()

                    HStack {
                        Text("Keuntungan Bersih")
                            .font(.subheadline)
                        Spacer()
                        Text(CurrencyFormatter.format(netProfit))
                            .font(.headline.bold())
                            .foregroundStyle(netProfit >= 0 ? .green : .red)
                    }

                    HStack {
                        Text("ROI")
                            .font(.subheadline)
                        Spacer()
                        Text(String(format: "%.1f%%", roiPercentage))
                            .font(.headline.bold())
                            .foregroundStyle(roiPercentage >= 0 ? .green : .red)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.04), radius: 3)

                // Cost Items Section
                if let costs = batch.costs, !costs.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rincian Biaya")
                            .font(.headline)

                        ForEach(costs) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.subheadline.bold())
                                    Text(item.costCategory.rawValue)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text(CurrencyFormatter.format(item.effectiveCost))
                                        .font(.subheadline.bold())
                                    if item.isShared {
                                        Text("Efektif (\(item.lifespanCycles ?? 1)x)")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Analisis ROI")
        .navigationBarTitleDisplayMode(.inline)
    }
}
