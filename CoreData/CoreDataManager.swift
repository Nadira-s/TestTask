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
    extension FeedViewModel {

        // Сохраняем посты в CoreData
        func savePostsToCoreData(_ posts: [Post]) {
            let context = CoreDataManager.shared.context

            // Удаляем старые посты
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PostEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
            } catch {
                print("CoreData delete error: \(error)")
            }

            // Сохраняем новые
            for post in posts {
                let entity = PostEntity(context: context)
                entity.id = Int64(post.id)
                entity.userId = Int64(post.userId)
                entity.title = post.title
                entity.body = post.body
            }

            CoreDataManager.shared.saveContext()
        }

        // Загружаем посты из CoreData
        func loadPostsFromCoreData() {
            let context = CoreDataManager.shared.context
            let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
            do {
                let savedPosts = try context.fetch(fetchRequest)
                self.allPosts = savedPosts.map { Post(id: Int($0.id),
                                                       userId: Int($0.userId),
                                                       title: $0.title ?? "",
                                                       body: $0.body ?? "") }
                self.resetPagination()
            } catch {
                print("CoreData fetch error: \(error)")
            }
        }
    }
}
