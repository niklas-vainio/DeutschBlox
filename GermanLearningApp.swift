//
//  GermanLearningApp.swift
//  GermanLearning
//
//  Created by Niklas on 14/07/2021.
//

import SwiftUI

@main
struct GermanLearningApp: App {
    // Initialise persitence controller
    let persistenceController = PersistenceController.shared
    
    // Environment property corresponding to app state (background, foreground etc.)
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            // Pass in managed object context as an environment object ^^^
        }
        .onChange(of: scenePhase, perform: { newScenePhase in
            // Run when app state changes
            switch newScenePhase {
                case .background:
                    // Save persistent data when entering background
                    print("App now in BACKGROUND")
                    persistenceController.save()
                case .inactive:
                    print("App now INACTIVE")
                case .active:
                    print("App now ACTIVE")
                @unknown default:
                    print("Unknown scene state ?!")
                }
        })
    }
}
