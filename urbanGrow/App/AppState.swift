import SwiftUI

enum Tab: Int, CaseIterable {
    case today = 0
    case batches = 1
    case gallery = 2
    case costs = 3
}

@Observable
final class AppState {
    var selectedTab: Tab = .today
    var isShowingCreateBatch: Bool = false
}
