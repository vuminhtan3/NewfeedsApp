//
//  PostEntity.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 14/06/2023.
//

import Foundation
struct PostEntity: Decodable {
    let title, content, address: String?
    let author: Author?
    let createdAt, updatedAt, id: String?
    
    enum CodingKeys: String, CodingKey {
        case title, content, address, author
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case id
    }
}

// MARK: - Author
struct Author: Decodable {
    let username, createdAt, updatedAt: String?
    let profile: Profile?
    let isAdmin: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case username
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case profile
        case isAdmin = "is_admin"
        case id
    }
}

// MARK: - Profile
struct Profile: Decodable {
    let bio, createdAt, updatedAt, gender: String?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case bio
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case gender, avatar
    }
}

