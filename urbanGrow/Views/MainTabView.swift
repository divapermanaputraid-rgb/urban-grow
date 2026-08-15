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
                Text("Today View")
                    .navigationTitle("Hari Ini")
            }
            .tabItem {
                Label("Hari Ini", systemImage: "sun.max")
            }
            .tag(Tab.today)

            NavigationStack(path: $batchesPath) {
                Text("Batches View")
                    .navigationTitle("Batch")
            }
            .tabItem {
                Label("Batch", systemImage: "square.grid.2x2")
            }
            .tag(Tab.batches)

            NavigationStack(path: $galleryPath) {
                Text("Gallery View")
                    .navigationTitle("Galeri")
            }
            .tabItem {
                Label("Galeri", systemImage: "photo.on.rectangle")
            }
            .tag(Tab.gallery)

            NavigationStack(path: $costsPath) {
                Text("Costs View")
                    .navigationTitle("Modal")
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
