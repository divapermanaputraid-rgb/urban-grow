//
//  urbanGrowApp.swift
//  urbanGrow
//
//  Created by MacBook on 16/08/26.
//

import SwiftUI
import SwiftData

@main
struct urbanGrowApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([
            Plant.self,
            Milestone.self,
            Batch.self,
            ScheduledTask.self,
            CostItem.self,
            HarvestLog.self,
            TaskPhoto.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
