//
//  NetworkManager.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 23/06/2023.
//

import Foundation
import Alamofire

class NetworkManager {
    static var shared = NetworkManager()
    
    private let session: Session!
    
    
    private init() {
//        self.session = Session()
        self.session = Session(interceptor: AuthenticateHandler())
        session.sessionConfiguration.timeoutIntervalForRequest = 30
    }
    
    func callAPI<T: Decodable>(router: URLRequestConvertible,
                               success: ((T) -> Void)?,
                               failure: ((APIError) -> Void)?) {
        session.request(router)
            .cURLDescription { description in
                print(description)
            }
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let entity):
                    success?(entity)
                case .failure(let afError):
//                    failure?(APIError.from(afError: afError))
                    
                    if let data = response.data {
                        do {
                            //Chuyển dữ liệu có kiểu là Data sang Dictionary (Dạng JSON)
                            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                            
                            if let json = jsonObject as? [String : Any] {
                                let message = json["message"] as? String?
                                failure?(APIError(errorMsg: message ?? "Something went wrong", errorKey: nil))
                            }
                        } catch {
                            print("Error")
                        }
                        //Chuyển data có kiểu dữ liệu là Data sang String
                        if let responseString = String(data: data, encoding: .utf8) {
                            failure?(APIError(errorMsg: responseString, errorKey: nil))
                        }
                    }
                    
                }
            }
    }
}
