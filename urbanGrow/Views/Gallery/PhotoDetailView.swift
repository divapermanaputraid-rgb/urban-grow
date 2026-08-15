import SwiftUI
import SwiftData

struct PhotoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let photo: TaskPhoto

    @State private var isShowingDeleteAlert: Bool = false

    private var image: UIImage? {
        PhotoStorageService.shared.loadPhoto(fileName: photo.fileName)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.black.ignoresSafeArea()

                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    ContentUnavailableView("Foto Tidak Ditemukan", systemImage: "photo.badge.exclamationmark")
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(photo.takenDate.formatted(date: .long, time: .shortened))
                        .font(.headline)
                    Spacer()
                    if let batchLabel = photo.task?.batch?.label {
                        Text(batchLabel)
                            .font(.caption.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .foregroundStyle(.green)
                            .clipShape(Capsule())
                    }
                }

                if let title = photo.task?.displayTitle {
                    Text("Task: \(title)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let note = photo.task?.note, !note.isEmpty {
                    Text("Catatan: \(note)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .navigationTitle("Detail Foto")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(role: .destructive) {
                    isShowingDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
        }
        .alert("Hapus Foto", isPresented: $isShowingDeleteAlert) {
            Button("Batal", role: .cancel) {}
            Button("Hapus", role: .destructive) {
                deletePhoto()
            }
        } message: {
            Text("Foto ini akan dihapus dari penyimpanan.")
        }
    }

    private func deletePhoto() {
        PhotoStorageService.shared.deletePhoto(fileName: photo.fileName)
        modelContext.delete(photo)
        try? modelContext.save()
        dismiss()
    }
}
