//
//  AuthRepository.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 05/06/2023.
//

import Foundation

protocol AuthRepository {
    /**
     
     */
    func login(username: String,
               password: String,
               success: ((LoginEntity) -> Void)?,
               failure: ((String?) -> Void)?)
}

class AuthRepositoryImpl: AuthRepository {
    var authAPIService: AuthAPIService
    
    init(authAPIService: AuthAPIService) {
        self.authAPIService = authAPIService
    }
    
    func login(username: String,
               password: String,
               success: ((LoginEntity) -> Void)?,
               failure: ((String?) -> Void)?) {
        authAPIService.login(username: username, password: password, success: success, failure: failure)
    }
}
