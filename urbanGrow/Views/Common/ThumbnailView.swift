import SwiftUI

struct ThumbnailView: View {
    let fileName: String

    private var image: UIImage? {
        PhotoStorageService.shared.loadPhoto(fileName: fileName)
    }

    var body: some View {
        GeometryReader { geo in
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.width)
                    .clipped()
                    .cornerRadius(8)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                }
                .frame(width: geo.size.width, height: geo.size.width)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
