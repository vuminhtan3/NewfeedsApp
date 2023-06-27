//
//  FavoriteListAPIService.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 19/06/2023.
//

import Foundation
import Alamofire

protocol FavoriteListAPIService {
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

class FavoriteListAPIServiceImpl: FavoriteListAPIService {
    
    func getPosts(page: Int,
                  pageSize: Int,
                  success: ((ArrayResponse<PostEntity>) -> Void)?,
                  failure: ((APIError?) -> Void)?) {
        let router = FavoriteRouter.getPosts(page: page, pageSize: pageSize)
        NetworkManager.shared.callAPI(router: router, success: success, failure: failure)
        
//        AF.request(router).cURLDescription { description in
//            print(description)
//        }
//        .validate(statusCode: 200..<300)
//        .responseDecodable(of: ArrayResponse<PostEntity>.self) { response in
//            switch response.result {
//            case .success(let entity):
//                success?(entity)
//            case .failure(let afError):
//                failure?(APIError.from(afError: afError))
//            }
//        }
    }
    
    func favorite(postID: String, success: ((ObjectResponse<FavoriteEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        let router = FavoriteRouter.favorite(postID: postID)
        
        NetworkManager.shared.callAPI(router: router, success: success, failure: failure)
//        AF.request(router).cURLDescription { description in
//            print(description)
//        }
//        .validate(statusCode: 200..<300)
//        .responseDecodable(of: ObjectResponse<FavoriteEntity>.self) { response in
//            switch response.result {
//            case .success(let entity):
//                success?(entity)
//            case .failure(let afError):
//                failure?(APIError.from(afError: afError))
//            }
//        }
    }
    
    func unFavorite(postID: String, success: ((ObjectResponse<FavoriteEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        let router = FavoriteRouter.unFavorite(postID: postID)
        
        NetworkManager.shared.callAPI(router: router, success: success, failure: failure)
//        AF.request(router).cURLDescription { description in
//            print(description)
//        }
//        .validate(statusCode: 200..<300)
//        .responseDecodable(of: ObjectResponse<FavoriteEntity>.self) { response in
//            switch response.result {
//            case .success(let entity):
//                success?(entity)
//            case .failure(let afError):
//                failure?(APIError.from(afError: afError))
//            }
//        }
    }
}
