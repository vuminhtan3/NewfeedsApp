//
//  FavoriteEntity.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 18/06/2023.
//

import Foundation

// MARK: - FavoriteEntity

struct FavoriteEntity: Codable {
    let author: Author?
    let createdAt, updatedAt: String?
    let isFavorite, isPin: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case author
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isFavorite, isPin, id
    }
}
