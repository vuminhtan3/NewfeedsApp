//
//  FavouriteRepository.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 18/06/2023.
//

import Foundation

protocol FavouriteRepository {
    /**
     
     */
    func getPosts(page: Int,
                  pageSize: Int,
                  success: ((ArrayResponse<PostEntity>) -> Void)?,
                  failure: ((APIError?) -> Void)?)
    func favourite(postID: String,
                success: ((ObjectResponse<FavouriteEntity>) -> Void)?,
                failure: ((APIError?) -> Void)?)
    func unFavourite(postID: String,
               success: ((ObjectResponse<FavouriteEntity>) -> Void)?,
               failure: ((APIError?) -> Void)?)
}

class FavouriteRepositoryImpl: FavouriteRepository {
    
    var favouriteAPIService: FavouriteListAPIService
    
    init(favouriteAPIService: FavouriteListAPIService) {
        self.favouriteAPIService = favouriteAPIService
    }
    
    func getPosts(page: Int, pageSize: Int, success: ((ArrayResponse<PostEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        favouriteAPIService.getPosts(page: page, pageSize: pageSize, success: success, failure: failure)
    }
    
    func favourite(postID: String, success: ((ObjectResponse<FavouriteEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        favouriteAPIService.favourite(postID: postID, success: success, failure: failure)
    }
    
    func unFavourite(postID: String, success: ((ObjectResponse<FavouriteEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        favouriteAPIService.unFavourite(postID: postID, success: success, failure: failure)
    }
}
