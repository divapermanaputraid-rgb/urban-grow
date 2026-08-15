import SwiftUI
import SwiftData

struct GalleryView: View {
    @Query(sort: \TaskPhoto.takenDate, order: .reverse) private var photos: [TaskPhoto]
    @Environment(AppState.self) private var appState

    @State private var filterPlant: String = "Semua"

    private var filterOptions: [String] {
        ["Semua"] + PlantType.allCases.map { $0.rawValue }
    }

    private var filteredPhotos: [TaskPhoto] {
        if filterPlant == "Semua" {
            return photos
        }
        return photos.filter { $0.task?.batch?.plant?.name == filterPlant }
    }

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        VStack(spacing: 0) {
            Picker("Filter Tanaman", selection: $filterPlant) {
                ForEach(filterOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            if filteredPhotos.isEmpty {
                EmptyStateView(
                    icon: "photo.on.rectangle",
                    title: "Belum Ada Foto",
                    message: "Ambil foto dokumentasi saat menyelesaikan task!",
                    actionTitle: "Lihat Task Hari Ini",
                    action: { appState.selectedTab = .today }
                )
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(filteredPhotos) { photo in
                            NavigationLink(destination: PhotoDetailView(photo: photo)) {
                                ThumbnailView(fileName: photo.fileName)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle("Galeri")
    }
}
