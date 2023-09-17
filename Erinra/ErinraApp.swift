//
//  ErinraApp.swift
//  Erinra
//
//  Created by Peter Hedlund on 8/31/23.
//

import SwiftUI
import SwiftData

@main
struct ErinraApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Reminder.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .modelContainer(sharedModelContainer)
        } label: {
            Label("Erinra", systemImage: "checklist.unchecked")
        }
        .menuBarExtraStyle(.window)
    }

}
