//
//  PostEntity.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 14/06/2023.
//

import Foundation

// MARK: - PostEntity
struct PostEntity: Codable {
    let title, content, address: String?
    let latitude, longitude: Int?
    let author: Author?
    let createdAt, updatedAt: String?
    let isFavorite, isPin: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case title, content, address, latitude, longitude, author
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isFavorite, isPin, id
    }
}

// MARK: - Author
struct Author: Codable {
    let username: String?
    let profile: Profile?
    let createdAt, updatedAt: String?
    let pointAmount: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case username, profile
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pointAmount = "point_amount"
        case id
    }
}

// MARK: - Profile
struct Profile: Codable {
    let bio: String?
    let avatar: String?
    let updatedAt, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case bio, avatar
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
}
