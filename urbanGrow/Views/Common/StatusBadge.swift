import SwiftUI

struct StatusBadge: View {
    let text: String
    let color: Color

    init(text: String, color: Color) {
        self.text = text
        self.color = color
    }

    init(status: TaskStatus) {
        switch status {
        case .pending:
            self.text = "Pending"
            self.color = .blue
        case .completed:
            self.text = "Selesai"
            self.color = .green
        case .skipped:
            self.text = "Dilewati"
            self.color = .gray
        case .delayed:
            self.text = "Ditunda"
            self.color = .orange
        }
    }

    init(status: BatchStatus) {
        switch status {
        case .growing:
            self.text = "Tumbuh"
            self.color = .green
        case .harvested:
            self.text = "Panen"
            self.color = .blue
        case .archived:
            self.text = "Arsip"
            self.color = .gray
        }
    }

    var body: some View {
        Text(text)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
