//
//  PostRepository.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 14/06/2023.
//

import Foundation

protocol PostRepository {
    /**
     
     */
    func getPosts(page: Int,
                  pageSize: Int,
                  success: ((ArrayResponse<PostEntity>) -> Void)?,
                  failure: ((APIError?) -> Void)?)
}

class PostRepositoryImpl: PostRepository {
    
    var postAPIService: PostAPIService
    
    init(postAPIService: PostAPIService) {
        self.postAPIService = postAPIService
    }
    
    func getPosts(page: Int, pageSize: Int, success: ((ArrayResponse<PostEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        postAPIService.getPosts(page: page, pageSize: pageSize, success: success, failure: failure)
    }
    
}
