//
//  CoreDataManager..swift
//  TestTask
//
//  Created by Nadira Seitkazy  on 09.12.2025.
//

import Foundation
import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FeedModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("CoreData load error: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("CoreData save error: \(error)")
            }
        }
    }
}
