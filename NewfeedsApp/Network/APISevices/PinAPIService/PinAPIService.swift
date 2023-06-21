//
//  PinAPIService.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 18/06/2023.
//

import Foundation
import Alamofire

protocol PinAPIService {
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

class PinAPIServiceImpl: PinAPIService {
    func getPosts(page: Int,
                  pageSize: Int,
                  success: ((ArrayResponse<PostEntity>) -> Void)?,
                  failure: ((APIError?) -> Void)?) {
        let router = PinRouter.getPosts(page: page, pageSize: pageSize)
        
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
    
    func pinPost(postID: String, success: ((ObjectResponse<PinEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        let router = PinRouter.pin(postID: postID)
        AF.request(router).cURLDescription { description in
            print(description)
        }
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ObjectResponse<PinEntity>.self) { response in
            switch response.result {
            case .success(let entity):
                success?(entity)
            case .failure(let afError):
                failure?(APIError.from(afError: afError))
            }
        }
    }
    
    func unPin(postID: String, success: ((ObjectResponse<PinEntity>) -> Void)?, failure: ((APIError?) -> Void)?) {
        let router = PinRouter.unPin(postID: postID)
        AF.request(router).cURLDescription { description in
            print(description)
        }
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ObjectResponse<PinEntity>.self) { response in
            switch response.result {
            case .success(let entity):
                success?(entity)
            case .failure(let afError):
                failure?(APIError.from(afError: afError))
            }
        }
    }
}
