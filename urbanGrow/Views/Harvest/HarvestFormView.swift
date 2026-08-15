import SwiftUI
import SwiftData
import PhotosUI

struct HarvestFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let batch: Batch

    @State private var date: Date = Date()
    @State private var weightGram: String = ""
    @State private var unit: String = "ikat"
    @State private var quantity: String = "1"
    @State private var marketPrice: String = ""
    @State private var note: String = ""
    @State private var isFinalHarvest: Bool = false

    @State private var capturedImage: UIImage? = nil
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var isShowingCamera: Bool = false

    private let unitOptions = ["gram", "kg", "ikat", "batang", "potongan", "buah"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Tanggal & Jumlah Panen") {
                    DatePicker("Tanggal Panen", selection: $date, displayedComponents: [.date, .hourAndMinute])

                    HStack {
                        Text("Berat (gram)")
                        Spacer()
                        TextField("Misal: 250", text: $weightGram)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Picker("Satuan Jumlah", selection: $unit) {
                            ForEach(unitOptions, id: \.self) { u in
                                Text(u).tag(u)
                            }
                        }
                    }

                    HStack {
                        Text("Jumlah (\(unit))")
                        Spacer()
                        TextField("Misal: 2", text: $quantity)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("Estimasi Nilai Pasar (Opsional)") {
                    HStack {
                        Text("Harga per \(unit) (Rp)")
                        Spacer()
                        TextField("Misal: 5000", text: $marketPrice)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("Catatan & Foto") {
                    TextEditor(text: $note)
                        .frame(height: 60)

                    if let capturedImage {
                        Image(uiImage: capturedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    HStack(spacing: 12) {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            Button {
                                isShowingCamera = true
                            } label: {
                                Label("Kamera", systemImage: "camera")
                            }
                            .buttonStyle(.bordered)
                        }

                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            Label("Galeri", systemImage: "photo")
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Section {
                    Toggle("Ini Panen Final (Tandai Batch Selesai)?", isOn: $isFinalHarvest)
                }
            }
            .navigationTitle("Catat Hasil Panen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        saveHarvest()
                    }
                }
            }
            .sheet(isPresented: $isShowingCamera) {
                ImagePicker(sourceType: .camera) { image in
                    capturedImage = image
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        await MainActor.run {
                            capturedImage = image
                        }
                    }
                }
            }
        }
    }

    private func saveHarvest() {
        let weight = Double(weightGram) ?? 0
        let qty = Double(quantity) ?? 1
        let price = Double(marketPrice)

        let harvest = HarvestLog(
            date: date,
            weightGram: weight,
            unit: unit,
            quantity: qty,
            marketPrice: price,
            note: note
        )
        harvest.batch = batch

        if let capturedImage, let photoModel = PhotoStorageService.shared.savePhoto(capturedImage, for: batch.id, taskId: nil) {
            photoModel.harvestLog = harvest
            modelContext.insert(photoModel)
        }

        if isFinalHarvest {
            batch.batchStatus = .harvested
        }

        modelContext.insert(harvest)
        try? modelContext.save()
        dismiss()
    }
}
