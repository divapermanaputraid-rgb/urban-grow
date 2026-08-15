import SwiftUI

struct TempCostItem: Identifiable {
    let id = UUID()
    var name: String = ""
    var amount: String = ""
    var category: CostCategory = .operational
    var isInfrastructure: Bool = false
    var expectedLifeCycles: Int = 1
}

struct ModalInputView: View {
    @Binding var costItems: [TempCostItem]
    var onNext: () -> Void
    var onBack: () -> Void

    var totalCost: Double {
        costItems.compactMap { Double($0.amount) }.reduce(0, +)
    }

    var body: some View {
        VStack {
            List {
                Section("Input Modal / Biaya Awal (Opsional)") {
                    ForEach($costItems) { $item in
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Nama item (misal: Bibit)", text: $item.name)
                            HStack {
                                Text("Rp")
                                TextField("Jumlah", text: $item.amount)
                                    .keyboardType(.numberPad)
                            }
                            Picker("Kategori", selection: $item.category) {
                                ForEach(CostCategory.allCases, id: \.self) { cat in
                                    Text(cat.rawValue).tag(cat)
                                }
                            }
                            Toggle("Infrastruktur (Bisa dipakai berulang)?", isOn: $item.isInfrastructure)
                            if item.isInfrastructure {
                                Stepper("Umur pakai: \(item.expectedLifeCycles) siklus", value: $item.expectedLifeCycles, in: 1...50)
                            }
                        }
                    }
                    .onDelete { indices in
                        costItems.remove(atOffsets: indices)
                    }

                    Button("+ Tambah Item Modal") {
                        costItems.append(TempCostItem())
                    }
                }

                if totalCost > 0 {
                    Section {
                        HStack {
                            Text("Total Biaya Awal")
                                .bold()
                            Spacer()
                            Text(CurrencyFormatter.format(totalCost))
                                .bold()
                        }
                    }
                }
            }

            HStack {
                Button("Kembali", action: onBack)
                    .buttonStyle(.bordered)
                Spacer()
                Button(costItems.isEmpty ? "Lewati" : "Lanjut", action: onNext)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
