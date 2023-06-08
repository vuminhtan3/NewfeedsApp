//
//  NetworkConstant.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 07/06/2023.
//

import Foundation
import Alamofire

struct NetworkConstant {
    static let domain = "https://learn-api-3t7z.onrender.com/login"
}

struct APIError {
    var errorCode: String?
    var errorMsg: String?
    var errorKey: String?
    
    static func from(afError: AFError) -> APIError {
        return APIError(errorMsg: afError.errorDescription)
    }
}
