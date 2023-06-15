//
//  PostEntity.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 14/06/2023.
//

import Foundation
struct PostEntity: Decodable {
    var id: String?
    var title: String?
    var address: String?
    var content: String?
    var author: UserEntity?
    var createAt: String?
    var updateAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, address, content, author
        case createAt = "create_at"
        case updateAt = "update_at"
    }
}

struct UserEntity: Decodable {
    var id: String?
    var username: String?
    var isAdmin: Bool
    var createAt: String?
    var updateAt: String?
    var profile: ProfileEntity?
    
    enum CodingKeys: String, CodingKey {
        case id, username, profile
        case createAt = "create_at"
        case updateAt = "update_at"
        case isAdmin = "is_admin"
    }
}

struct ProfileEntity: Decodable {
    var bio: String?
    var createAt: String
    var updateAt: String
    var gender: String?
    var avatar: String?
    
    enum CodingKeys: String, CodingKey {
        case bio, gender, avatar
        case createAt = "create_at"
        case updateAt = "update_at"
    }
}
