//
//  PinRepository.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 18/06/2023.
//

import Foundation

protocol PinRepository {
    /**
     
     */
    func getPosts(page: Int,
                  pageSize: Int,
                  success: ((ArrayResponse<PostEntity>) -> Void)?,
                  failure: ((APIError?) -> Void)?)
    func pinPost(postID: String,
                success: ((ObjectResponse<PinEntity>) -> Void)?,
                failure: ((APIError?) -> Void)?)
    func unPin(postID: String,
               success: ((ObjectResponse<PinEntity>) -> Void)?,
               failure: ((APIError?) -> Void)?)
}

class PinRepositoryImpl: PinRepository {
    
    var pinAPIService: PinAPIService
    
    init(pinAPIService: PinAPIService) {
        self.pinAPIService = pinAPIService
    }
    
    func getPosts(page: Int, pageSize: Int, success: ((ArrayResponse<PostEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        pinAPIService.getPosts(page: page, pageSize: pageSize, success: success, failure: failure)
    }
    func pinPost(postID: String, success: ((ObjectResponse<PinEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        pinAPIService.pinPost(postID: postID, success: success, failure: failure)
    }
    func unPin(postID: String, success: ((ObjectResponse<PinEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        pinAPIService.unPin(postID: postID, success: success, failure: failure)
    }
}
