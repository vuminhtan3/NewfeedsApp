//
//  UserAPIRouter.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 26/06/2023.
//

import Foundation
import Alamofire

enum UserAPIServiceRouter: URLRequestConvertible {
    case profile
    case updateProfile(body: Parameters)
    case updateAvatar

    var baseURL: URL {
        return URL(string: NetworkConstant.domain)!
    }

    var method: HTTPMethod {
        switch self {
        case .profile:
            return .get
        case .updateProfile:
            return .put
        case .updateAvatar:
            return .post
        }
    }

    var path: String {
        switch self {
        case .profile:
            return "profile"
        case .updateProfile:
            return "profile"
        case .updateAvatar:
            return "users/avatar"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .updateProfile(let body):
            return body
        default:
            return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        if AuthService.share.isLoggedIn {
            let accessToken = AuthService.share.accessToken
            request.setValue(String(format: "Bearer %@", accessToken),
                             forHTTPHeaderField: "Authorization")
        }
        switch self.method {
        case .get:
            request = try URLEncoding.default.encode(request, with: parameters)
        default:
            request = try JSONEncoding.default.encode(request, with: parameters)
        }
        
//        if self == .updateAvatar {
//            request.setValue("multipart/form-data", forHTTPHeaderField: "Content-type")
//        }
        return request
    }
}
