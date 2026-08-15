import SwiftUI

struct BatchInfoView: View {
    @Binding var label: String
    @Binding var startDate: Date
    @Binding var reminderTime: Date
    var onNext: () -> Void
    var onBack: () -> Void

    var body: some View {
        Form {
            Section("Info Batch") {
                TextField("Label Batch (misal: Batch #1)", text: $label)
                DatePicker("Tanggal Tanam", selection: $startDate, displayedComponents: .date)
                DatePicker("Jam Reminder", selection: $reminderTime, displayedComponents: .hourAndMinute)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button("Kembali", action: onBack)
                    .buttonStyle(.bordered)
                Spacer()
                Button("Lanjut", action: onNext)
                    .buttonStyle(.borderedProminent)
                    .disabled(label.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
}
