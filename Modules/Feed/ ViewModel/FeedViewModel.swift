import Foundation

final class FeedViewModel {
    
    var posts: [PostEntity] = []
    var onUpdate: (() -> Void)?
    
    func loadPosts() {
        NetworkService.shared.loadPosts { result in
            switch result {
            case .success(let posts):
                CoreDataManager.shared.savePosts(posts)
                self.posts = CoreDataManager.shared.loadPosts()
                DispatchQueue.main.async { self.onUpdate?() }
                
            case .failure:
                // offline fallback
                self.posts = CoreDataManager.shared.loadPosts()
                DispatchQueue.main.async { self.onUpdate?() }
            }
        }
    }
}

