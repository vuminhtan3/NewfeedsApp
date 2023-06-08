//
//  AuthAPIService.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 05/06/2023.
//

import Foundation
import Alamofire

protocol AuthAPIService {
    func login(username: String,
               password: String,
               success: ((LoginEntity) -> Void)?,
               failure: ((String?) -> Void)?)
}

class AuthAPIServiceImpl: AuthAPIService {
    func login(username: String,
               password: String,
               success: ((LoginEntity) -> Void)?,
               failure: ((String?) -> Void)?) {
        
        // Send request call API onto sever
        AF.request("https://learn-api-3t7z.onrender.com/login",
                   method: .post,
                   parameters: [
                    "username" : username,
                    "password": password
                   ], encoder: JSONParameterEncoder.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: LoginEntity.self) { response in
            switch response.result {
            case .success(let entity):
                //Case API success:
                success?(entity)
            case .failure(let error):
                //Call API failure
                failure?(error.failureReason) // haven't handled the error yet
            }
        }
    }
}
