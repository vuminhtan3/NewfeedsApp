//
//  FavouriteListAPIService.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 19/06/2023.
//

import Foundation
import Alamofire

protocol FavouriteListAPIService {
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

class FavouriteListAPIServiceImpl: FavouriteListAPIService {
    
    func getPosts(page: Int,
                  pageSize: Int,
                  success: ((ArrayResponse<PostEntity>) -> Void)?,
                  failure: ((APIError?) -> Void)?) {
        let router = FavouriteRouter.getPosts(page: page, pageSize: pageSize)
        
        AF.request(router).cURLDescription { description in
            print(description)
        }
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ArrayResponse<PostEntity>.self) { response in
            switch response.result {
            case .success(let entity):
                success?(entity)
            case .failure(let afError):
                failure?(APIError.from(afError: afError))
            }
        }
    }
    
    func favourite(postID: String, success: ((ObjectResponse<FavouriteEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        let router = FavouriteRouter.favourite(postID: postID)
        AF.request(router).cURLDescription { description in
            print(description)
        }
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ObjectResponse<FavouriteEntity>.self) { response in
            switch response.result {
            case .success(let entity):
                success?(entity)
            case .failure(let afError):
                failure?(APIError.from(afError: afError))
            }
        }
    }
    
    func unFavourite(postID: String, success: ((ObjectResponse<FavouriteEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        let router = FavouriteRouter.unFavourite(postID: postID)
        AF.request(router).cURLDescription { description in
            print(description)
        }
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ObjectResponse<FavouriteEntity>.self) { response in
            switch response.result {
            case .success(let entity):
                success?(entity)
            case .failure(let afError):
                failure?(APIError.from(afError: afError))
            }
        }
    }
}
