//
//  NetworkConstant.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 07/06/2023.
//

import Foundation
import Alamofire

struct NetworkConstant {
    static let domain = "http://ec2-3-115-5-1.ap-northeast-1.compute.amazonaws.com"
}

struct APIError {
    var errorCode: String?
    var errorMsg: String?
    var errorKey: String?
    
    static func from(afError: AFError) -> APIError {
        return APIError(errorMsg: afError.errorDescription)
    }
}
