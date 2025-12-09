//
//  NetworkService.swift
//  TestTask
//
//  Created by Nadira Seitkazy  on 09.12.2025.
//

import Foundation
import Alamofire

final class NetworkService {

    static let shared = NetworkService()
    private init() {}

    private let baseURL = "https://jsonplaceholder.typicode.com"

    // Fetch posts
    func getPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let url = baseURL + "/posts"

        AF.request(url)
            .validate()
            .responseDecodable(of: [Post].self) { response in
                switch response.result {
                case .success(let posts):
                    completion(.success(posts))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    // Fetch users
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = baseURL + "/users"

        AF.request(url)
            .validate()
            .responseDecodable(of: [User].self) { response in
                switch response.result {
                case .success(let users):
                    completion(.success(users))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
