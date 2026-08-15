import SwiftUI
import SwiftData

struct CostInputView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var batches: [Batch]

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var category: CostCategory = .operational
    @State private var date: Date = Date()
    @State private var isInfrastructure: Bool = false
    @State private var lifespanCycles: Int = 1
    @State private var selectedBatch: Batch?

    var body: some View {
        NavigationStack {
            Form {
                Section("Detail Biaya") {
                    TextField("Nama Item (misal: Pupuk NPK)", text: $name)
                    HStack {
                        Text("Rp")
                        TextField("Jumlah", text: $amount)
                            .keyboardType(.numberPad)
                    }
                    Picker("Kategori", selection: $category) {
                        ForEach(CostCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    DatePicker("Tanggal", selection: $date, displayedComponents: .date)
                }

                Section("Infrastruktur / Alat") {
                    Toggle("Infrastruktur (Bisa dipakai berulang)?", isOn: $isInfrastructure)
                    if isInfrastructure {
                        Stepper("Umur pakai: \(lifespanCycles) siklus", value: $lifespanCycles, in: 1...50)
                    }
                }

                Section("Alokasi Batch (Opsional)") {
                    Picker("Batch", selection: $selectedBatch) {
                        Text("Tanpa Batch (Umum)").tag(nil as Batch?)
                        ForEach(batches) { batch in
                            Text(batch.label).tag(batch as Batch?)
                        }
                    }
                }
            }
            .navigationTitle("Tambah Modal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        saveCost()
                    }
                    .disabled(name.isEmpty || Double(amount) == nil)
                }
            }
        }
    }

    private func saveCost() {
        guard let costAmount = Double(amount) else { return }

        let newItem = CostItem(
            name: name,
            amount: costAmount,
            category: category,
            date: date,
            lifespanCycles: isInfrastructure ? lifespanCycles : nil,
            isShared: isInfrastructure
        )
        if let selectedBatch {
            newItem.batch = selectedBatch
        }

        modelContext.insert(newItem)
        try? modelContext.save()
        dismiss()
    }
}
