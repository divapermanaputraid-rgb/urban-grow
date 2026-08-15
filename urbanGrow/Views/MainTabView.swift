import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState
    @State private var todayPath = NavigationPath()
    @State private var batchesPath = NavigationPath()
    @State private var galleryPath = NavigationPath()
    @State private var costsPath = NavigationPath()

    var body: some View {
        @Bindable var state = appState
        TabView(selection: $state.selectedTab) {
            NavigationStack(path: $todayPath) {
                TodayView()
            }
            .tabItem {
                Label("Hari Ini", systemImage: "sun.max")
            }
            .tag(Tab.today)

            NavigationStack(path: $batchesPath) {
                BatchListView()
            }
            .tabItem {
                Label("Batch", systemImage: "square.grid.2x2")
            }
            .tag(Tab.batches)

            NavigationStack(path: $galleryPath) {
                GalleryView()
            }
            .tabItem {
                Label("Galeri", systemImage: "photo.on.rectangle")
            }
            .tag(Tab.gallery)

            NavigationStack(path: $costsPath) {
                CostTrackerView()
            }
            .tabItem {
                Label("Modal", systemImage: "dollarsign.circle")
            }
            .tag(Tab.costs)
        }
    }
}

#Preview {
    MainTabView()
        .environment(AppState())
}
