//
//  RegisterEntity.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 09/06/2023.
//

import Foundation

struct RegisterEntity: Decodable {
    var userID: String?
    var accessToken: String?
    var refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
