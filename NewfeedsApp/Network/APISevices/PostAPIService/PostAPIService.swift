//
//  PostAPIService.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 14/06/2023.
//

import Foundation
import Alamofire

protocol PostAPIService {
    func getPosts(page: Int,
                  pageSize: Int,
                  success: ((ArrayResponse<PostEntity>) -> Void)?,
                  failure: ((APIError?) -> Void)?)
}

class PostAPIServiceImpl: PostAPIService {
    func getPosts(page: Int,
                  pageSize: Int,
                  success: ((ArrayResponse<PostEntity>) -> Void)?,
                  failure: ((APIError?) -> Void)?) {
        let router = PostRouter.getPosts(page: page, pageSize: pageSize)
        
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
}
