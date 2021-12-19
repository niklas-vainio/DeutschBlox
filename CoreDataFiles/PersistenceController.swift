//
//  PersistenceController.swift
//  GermanLearning
//
//  Created by Niklas on 22/07/2021.
//  This file defines a PersistenceController struct which exists within a singleton pattern
//  Handles saving and deleting data from the core data store

import Foundation
import CoreData

struct PersistenceController {
    // Singleton pattern
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    // Init method
    init() {
        // Initialise persistence container to use model file
        container = NSPersistentContainer(name: "PersistentData")
        
        // Load persistent data
        container.loadPersistentStores { (desc, error) in
            // Crash app if any errors
            if let error = error {
                fatalError("Error on initial load: \(error.localizedDescription)")
            }
        }
    }
    
    // Save function
    func save() {
        let context = container.viewContext
        
        // Save if any changes
        if context.hasChanges {
            do {
                try context.save()
                print("Successfully saved!")
            } catch {
                print("Error saving: \(error.localizedDescription)")
            }
        }
    }
    
    // Delete function
    func delete(object: NSManagedObject) {
        let context = container.viewContext
        context.delete(object)
        
        save()
    }
}
