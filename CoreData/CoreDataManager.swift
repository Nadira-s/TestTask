import Foundation
import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FeedModel") // имя модели .xcdatamodeld
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading CoreData: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }

    // MARK: - Save posts from API
    func savePosts(_ posts: [Post]) {
        do {
            // удаляем старые данные (чтобы не дублировались)
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            try context.execute(request)

            // сохраняем новые
            for post in posts {
                let entity = PostEntity(context: context)
                entity.id = Int64(post.id)
                entity.userId = Int64(post.userId)
                entity.title = post.title
                entity.body = post.body
                entity.isLiked = false
            }

            saveContext()
        } catch {
            print("Error saving posts: \(error)")
        }
    }

    // MARK: - Load posts for offline
    func loadPosts() -> [PostEntity] {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching posts: \(error)")
            return []
        }
    }
}

