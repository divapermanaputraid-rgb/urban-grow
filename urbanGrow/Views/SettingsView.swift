import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var photos: [TaskPhoto]

    @State private var defaultReminderTime: Date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var isShowingResetAlert: Bool = false
    @State private var resetConfirmationText: String = ""
    @State private var orphanCountMessage: String? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section("Pengingat Defaults") {
                    DatePicker("Jam Reminder Default", selection: $defaultReminderTime, displayedComponents: .hourAndMinute)
                }

                Section("Pemeliharaan Data") {
                    Button("Bersihkan Foto Yatim (Orphan)") {
                        cleanupOrphanPhotos()
                    }

                    if let orphanCountMessage {
                        Text(orphanCountMessage)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Button(role: .destructive) {
                        isShowingResetAlert = true
                    } label: {
                        Text("Reset Semua Data Aplikasi")
                    }
                }

                Section("Tentang") {
                    HStack {
                        Text("Versi Aplikasi")
                        Spacer()
                        Text("1.0.0 (iOS Native)")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Sistem Penyimpanan")
                        Spacer()
                        Text("SwiftData (Offline First)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Pengaturan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Selesai") { dismiss() }
                }
            }
            .alert("Reset Semua Data?", isPresented: $isShowingResetAlert) {
                TextField("Ketik RESET untuk konfirmasi", text: $resetConfirmationText)
                Button("Batal", role: .cancel) { resetConfirmationText = "" }
                Button("Hapus Semua Data", role: .destructive) {
                    if resetConfirmationText.uppercased() == "RESET" {
                        resetAllData()
                    }
                    resetConfirmationText = ""
                }
            } message: {
                Text("PERINGATAN: Semua batch, task, catatan modal, hasil panen, dan foto dokumentasi akan dihapus secara permanen.")
            }
        }
    }

    private func cleanupOrphanPhotos() {
        let fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Photos", isDirectory: true)

        guard let enumerator = fileManager.enumerator(at: docs, includingPropertiesForKeys: nil) else { return }

        let validPaths = Set(photos.map { $0.fileName })
        var deletedCount = 0

        for case let fileURL as URL in enumerator {
            guard !fileURL.hasDirectoryPath else { continue }
            let relativePath = fileURL.path.replacingOccurrences(of: docs.path + "/", with: "")
            if !validPaths.contains(relativePath) {
                try? fileManager.removeItem(at: fileURL)
                deletedCount += 1
            }
        }

        orphanCountMessage = "Ditemukan dan dihapus \(deletedCount) foto yatim."
    }

    private func resetAllData() {
        do {
            try modelContext.delete(model: Batch.self)
            try modelContext.delete(model: ScheduledTask.self)
            try modelContext.delete(model: CostItem.self)
            try modelContext.delete(model: HarvestLog.self)
            try modelContext.delete(model: TaskPhoto.self)
            try modelContext.save()

            let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("Photos", isDirectory: true)
            try? FileManager.default.removeItem(at: docs)

            // Re-seed plant templates if needed
            SeedData.seedIfNeeded(context: modelContext)
            dismiss()
        } catch {
            print("Reset error: \(error)")
        }
    }
}
