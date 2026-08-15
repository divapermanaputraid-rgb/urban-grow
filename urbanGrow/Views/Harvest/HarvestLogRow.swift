import SwiftUI

struct HarvestLogRow: View {
    let log: HarvestLog

    var body: some View {
        HStack(spacing: 12) {
            if let photo = log.photo, let uiImage = PhotoStorageService.shared.loadPhoto(fileName: photo.fileName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green.opacity(0.15))
                    Image(systemName: "basket")
                        .font(.title2)
                        .foregroundStyle(.green)
                }
                .frame(width: 50, height: 50)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(log.displayQuantity)
                        .font(.headline)
                    Spacer()
                    if let totalValue = log.totalValue {
                        Text(CurrencyFormatter.format(totalValue))
                            .font(.subheadline.bold())
                            .foregroundStyle(.green)
                    }
                }

                HStack {
                    Text(log.date.formatted(date: .abbreviated, time: .shortened))
                    if let price = log.marketPrice {
                        Text("• \(CurrencyFormatter.format(price))/\(log.unit)")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                if !log.note.isEmpty {
                    Text(log.note)
                        .font(.caption2)
                        .italic()
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 3)
    }
}
