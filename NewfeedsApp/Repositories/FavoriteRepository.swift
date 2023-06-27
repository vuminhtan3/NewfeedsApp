//
//  FavoriteRepository.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 18/06/2023.
//

import Foundation

protocol FavoriteRepository {
    /**
     
     */
    func getPosts(page: Int,
                  pageSize: Int,
                  success: ((ArrayResponse<PostEntity>) -> Void)?,
                  failure: ((APIError?) -> Void)?)
    func favorite(postID: String,
                success: ((ObjectResponse<FavoriteEntity>) -> Void)?,
                failure: ((APIError?) -> Void)?)
    func unFavorite(postID: String,
               success: ((ObjectResponse<FavoriteEntity>) -> Void)?,
               failure: ((APIError?) -> Void)?)
}

class FavoriteRepositoryImpl: FavoriteRepository {
    
    var favoriteAPIService: FavoriteListAPIService
    
    init(favoriteAPIService: FavoriteListAPIService) {
        self.favoriteAPIService = favoriteAPIService
    }
    
    func getPosts(page: Int, pageSize: Int, success: ((ArrayResponse<PostEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        favoriteAPIService.getPosts(page: page, pageSize: pageSize, success: success, failure: failure)
    }
    
    func favorite(postID: String, success: ((ObjectResponse<FavoriteEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        favoriteAPIService.favorite(postID: postID, success: success, failure: failure)
    }
    
    func unFavorite(postID: String, success: ((ObjectResponse<FavoriteEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        favoriteAPIService.unFavorite(postID: postID, success: success, failure: failure)
    }
}
