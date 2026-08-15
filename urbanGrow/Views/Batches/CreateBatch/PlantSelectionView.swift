import SwiftUI
import SwiftData

struct PlantSelectionView: View {
    @Query var plants: [Plant]
    @Binding var selectedPlant: Plant?
    var onNext: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pilih Tanaman")
                .font(.headline)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(plants) { plant in
                        let isSelected = selectedPlant?.id == plant.id
                        let color = Color(hex: plant.colorHex)

                        HStack(spacing: 16) {
                            Image(systemName: plant.icon)
                                .font(.title)
                                .foregroundStyle(color)
                                .frame(width: 50, height: 50)
                                .background(color.opacity(0.15))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(plant.name)
                                    .font(.headline)
                                Text("\(plant.milestones?.count ?? 0) Milestone")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(color)
                                    .font(.title2)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? color : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                        )
                        .onTapGesture {
                            selectedPlant = plant
                        }
                    }
                }
            }

            Button("Lanjut") {
                onNext()
            }
            .buttonStyle(.borderedProminent)
            .disabled(selectedPlant == nil)
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}
