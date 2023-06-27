//
//  UserRepository.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 26/06/2023.
//

import Foundation

protocol UserRepository {
    func profile(success: ((ObjectResponse<Author>) -> Void)?,
                 failure: ((APIError?) -> Void)?)
    
    func updateProfile(gender: String?,
                       bio: String?,
                       avatar: String?,
                       success: ((ObjectResponse<Author>) -> Void)?,
                       failure: ((APIError?) -> Void)?)
    
    func updateAvatar(avatar data: Data,
                      success: ((ObjectResponse<Author>) -> Void)?,
                      failure: ((APIError?) -> Void)?)
}

class UserRepositoryImpl: UserRepository {
    
    var userAPIService: UserAPIService
    init(userAPIService: UserAPIService) {
        self.userAPIService = userAPIService
    }
    
    func profile(success: ((ObjectResponse<Author>) -> Void)?, failure: ((APIError?) -> Void)?) {
        userAPIService.profile(success: success, failure: failure)
    }
    
    func updateProfile(gender: String?, bio: String?, avatar: String?, success: ((ObjectResponse<Author>) -> Void)?, failure: ((APIError?) -> Void)?) {
        userAPIService.updateProfile(gender: gender, bio: bio, avatar: avatar, success: success, failure: failure)
    }
    
    func updateAvatar(avatar data: Data, success: ((ObjectResponse<Author>) -> Void)?, failure: ((APIError?) -> Void)?) {
        userAPIService.updateAvatar(avatar: data, success: success, failure: failure)
    }
}
