import SwiftUI
import SwiftData
import PhotosUI

struct CompleteTaskSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let task: ScheduledTask

    @State private var completedDate: Date = Date()
    @State private var note: String = ""
    @State private var capturedImages: [UIImage] = []
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var isShowingCamera: Bool = false

    @State private var errorMessage: String? = nil
    @State private var isShowingErrorAlert: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        DayCounterView(day: task.plannedDayOffset)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.displayTitle)
                                .font(.headline)
                            if !task.displayDescription.isEmpty {
                                Text(task.displayDescription)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Tanggal Dikerjakan") {
                    DatePicker("Tanggal", selection: $completedDate, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Catatan") {
                    TextEditor(text: $note)
                        .frame(height: 80)
                }

                Section("Foto Dokumentasi") {
                    if !capturedImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(0..<capturedImages.count, id: \.self) { index in
                                    Image(uiImage: capturedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
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
            }
            .navigationTitle("Selesaikan Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        saveCompletedTask()
                    }
                    .bold()
                }
            }
            .sheet(isPresented: $isShowingCamera) {
                ImagePicker(sourceType: .camera) { image in
                    capturedImages.append(image)
                }
            }
            .onChange(of: selectedPhotoItem) { newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        await MainActor.run {
                            capturedImages.append(image)
                        }
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .alert("Gagal Menyimpan", isPresented: $isShowingErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Terjadi kesalahan saat menyimpan data.")
        }
    }

    private func saveCompletedTask() {
        task.completedDate = completedDate
        task.note = note
        task.taskStatus = .completed

        let diff = Calendar.current.dateComponents([.day], from: task.plannedDate, to: completedDate).day ?? 0
        task.delayDays = max(0, diff)

        if let batchId = task.batch?.id {
            for image in capturedImages {
                if let photoModel = PhotoStorageService.shared.savePhoto(image, for: batchId, taskId: task.id) {
                    photoModel.task = task
                    modelContext.insert(photoModel)
                }
            }
        }

        NotificationService.shared.cancelNotification(for: task.id)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            isShowingErrorAlert = true
        }
    }
}
