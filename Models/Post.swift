//
//  Post.swift
//  TestTask
//
//  Created by Nadira Seitkazy  on 09.12.2025.
//

struct Post: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
