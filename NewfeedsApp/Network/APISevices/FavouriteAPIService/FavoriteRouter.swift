//
//  FavoriteRouter.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 19/06/2023.
//

import Foundation
import Alamofire

enum FavoriteRouter: URLRequestConvertible {
    case getPosts(page: Int, pageSize: Int)
    case favorite(postID: String)
    case unFavorite(postID: String)
    
    var baseURL: URL {
        return URL(string: NetworkConstant.domain)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPosts:
            return .get
        case .favorite:
            return .post
        case .unFavorite:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return "favorites"
        case .favorite:
            return "favorites"
        case .unFavorite:
            return "favorites"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getPosts(let page, let pageSize):
            return [
                "page": page,
                "pageSize": pageSize
            ]
        case .favorite(let postID):
            return [
                "post_id": postID
            ]
        case .unFavorite(let postID):
            return [
                "post_id" : postID
            ]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        //Kiểm tra xem đã login hay chưa, nếu login rồi thì gán accessToken thì gán vào header có field là "Authorization"
        if AuthService.share.isLoggedIn {
            let accessToken = AuthService.share.accessToken
            request.setValue(String(format: "Bearer %@", accessToken),
                             forHTTPHeaderField: "Authorization")
        }
        
//        switch self.method {
//        case .get:
//            request = try URLEncoding.default.encode(request, with: parameters)
//        case .post:
//            request = try JSONEncoding.default.encode(request, with: parameters)
//        case .delete:
//            request = try JSONEncoding.default.encode(request, with: parameters)
//        default:
//            request = try JSONEncoding.default.encode(request, with: parameters)
//        }
        
        switch self {
        case .getPosts, .unFavorite:
            request = try URLEncoding.default.encode(request, with: parameters)
        case .favorite:
            request = try JSONEncoding.default.encode(request, with: parameters)
        }
        request.timeoutInterval = 10
        return request
    }
}
