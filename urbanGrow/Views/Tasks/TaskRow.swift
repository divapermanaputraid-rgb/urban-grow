import SwiftUI

struct TaskRow: View {
    let task: ScheduledTask
    var onComplete: (() -> Void)? = nil
    var onDelayOneDay: (() -> Void)? = nil
    var onSkip: ((String) -> Void)? = nil

    @State private var isShowingSkipAlert: Bool = false
    @State private var skipReason: String = ""

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            DayCounterView(day: task.plannedDayOffset, isOverdue: task.isOverdue)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(task.displayTitle)
                        .font(.headline)
                    Spacer()
                    StatusBadge(status: task.taskStatus)
                }

                if !task.displayDescription.isEmpty {
                    Text(task.displayDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                HStack {
                    Label(task.plannedDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    Spacer()
                    if let deviation = task.deviationText {
                        Text(deviation)
                            .foregroundStyle(.orange)
                    }
                }
                .font(.caption2)
                .foregroundStyle(.secondary)

                if !task.note.isEmpty {
                    Text("Catatan: \(task.note)")
                        .font(.caption2)
                        .italic()
                        .foregroundStyle(.primary.opacity(0.8))
                        .padding(6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                }

                if let photos = task.photos, !photos.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(photos) { photo in
                                if let uiImage = PhotoStorageService.shared.loadPhoto(fileName: photo.fileName) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 44, height: 44)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3)
        .contextMenu {
            if task.taskStatus == .pending || task.taskStatus == .delayed {
                Button(role: .destructive) {
                    isShowingSkipAlert = true
                } label: {
                    Label("Lewati Task", systemImage: "forward.end")
                }
            }
        }
        .alert("Lewati Task", isPresented: $isShowingSkipAlert) {
            TextField("Alasan (opsional)", text: $skipReason)
            Button("Batal", role: .cancel) { skipReason = "" }
            Button("Lewati", role: .destructive) {
                onSkip?(skipReason)
                skipReason = ""
            }
        } message: {
            Text("Apakah kamu yakin ingin melewati task ini?")
        }
        .swipeActions(edge: .leading) {
            if task.taskStatus == .pending || task.taskStatus == .delayed {
                Button {
                    onComplete?()
                } label: {
                    Label("Selesai", systemImage: "checkmark")
                }
                .tint(.green)
            }
        }
        .swipeActions(edge: .trailing) {
            if task.taskStatus == .pending || task.taskStatus == .delayed {
                Button {
                    onDelayOneDay?()
                } label: {
                    Label("Tunda 1 Hari", systemImage: "clock.arrow.circlepath")
                }
                .tint(.orange)
            }
        }
    }
}
