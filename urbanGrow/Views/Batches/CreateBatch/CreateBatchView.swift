import SwiftUI
import SwiftData

struct CreateBatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var currentStep: Int = 1
    @State private var selectedPlant: Plant?
    @State private var label: String = ""
    @State private var startDate: Date = Date()
    @State private var reminderTime: Date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var costItems: [TempCostItem] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Step Bar
                HStack(spacing: 8) {
                    ForEach(1...4, id: \.self) { step in
                        Capsule()
                            .fill(step <= currentStep ? Color.green : Color.gray.opacity(0.3))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Group {
                    switch currentStep {
                    case 1:
                        PlantSelectionView(selectedPlant: $selectedPlant, onNext: { currentStep = 2 })
                    case 2:
                        BatchInfoView(label: $label, startDate: $startDate, reminderTime: $reminderTime, onNext: { currentStep = 3 }, onBack: { currentStep = 1 })
                    case 3:
                        ModalInputView(costItems: $costItems, onNext: { currentStep = 4 }, onBack: { currentStep = 2 })
                    case 4:
                        RoadmapPreviewView(plant: selectedPlant, startDate: startDate, onCreate: createBatch, onBack: { currentStep = 3 })
                    default:
                        EmptyView()
                    }
                }
            }
            .navigationTitle("Buat Batch Baru")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
            }
        }
    }

    private func createBatch() {
        guard let plant = selectedPlant else { return }

        let newBatch = Batch(label: label, startDate: startDate, status: .growing)
        newBatch.plant = plant
        modelContext.insert(newBatch)

        // Generate tasks from plant milestones
        if let milestones = plant.milestones {
            for milestone in milestones {
                let pDate = Calendar.current.date(byAdding: .day, value: milestone.dayOffset, to: startDate) ?? startDate
                let task = ScheduledTask(
                    plannedDayOffset: milestone.dayOffset,
                    plannedDate: pDate,
                    reminderTime: reminderTime
                )
                task.batch = newBatch
                task.milestone = milestone
                modelContext.insert(task)

                NotificationService.shared.scheduleNotification(for: task)
            }
        }

        // Add initial cost items
        for tempItem in costItems {
            guard let amount = Double(tempItem.amount), amount > 0 else { continue }
            let item = CostItem(
                name: tempItem.name.isEmpty ? "Biaya" : tempItem.name,
                amount: amount,
                category: tempItem.category,
                date: startDate,
                lifespanCycles: tempItem.isInfrastructure ? tempItem.expectedLifeCycles : nil,
                isShared: tempItem.isInfrastructure
            )
            item.batch = newBatch
            modelContext.insert(item)
        }

        try? modelContext.save()
        dismiss()
    }
}
