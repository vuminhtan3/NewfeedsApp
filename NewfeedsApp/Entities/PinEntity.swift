//
//  PinEntity.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 18/06/2023.
//

import Foundation

struct PinEntity: Codable {
    let isPin, isFavorite: Bool?
    let user, postID, createdAt, updatedAt: String?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case isPin, isFavorite, user
        case postID = "post"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case id
    }
}
