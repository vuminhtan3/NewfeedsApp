//
//  LoginPresenter.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 05/06/2023.
//

import Foundation

/**
 Xử lý bussiness login
 */

protocol LoginPresenter {
    func login(username: String, password: String)
}

protocol RegisterPresenter {
    func register(username: String, password: String, confirmPassword: String)
}

class LoginPresenterImpl: LoginPresenter {
    
    var controller: LoginDisplay
    var authRepository: AuthRepository
    
    init(controller: LoginDisplay, authRepository: AuthRepository) {
        self.controller = controller
        self.authRepository = authRepository
    }
    
//    func validateForm() -> Bool {
//        return false
//    }
    
    func login(username: String, password: String) {
        //Check validate username
        if username.isEmpty {
            controller.validateFailure(feild: "username", message: "Username is required")
        } else {
            //Show loading
            authRepository.login(username: username, password: password) { response in
                // Turn off loading
                // Check the response have data yet?
            } failure: { errorMsg in
                // Turn off loading
                //Return error message for viewcontroller
            }
        }
        if password.isEmpty {
            controller.validateFailure(feild: "password", message: "Password is required")
        } else {
            authRepository.login(username: username, password: password) { response in
                //Turn of loading
                //Check the response have data yet?
            } failure: { errorMsg in
                //Turn off loading
                //Return error message to viewcontroller
            }
        }
        
        if username.count < 4 {
            controller.validateFailure(feild: "username", message: "Username must be at least 4 characters")
        } else {
            authRepository.login(username: username, password: password) { response in
                
            } failure: { errorMsg in
                
            }

        }
        
        if username.count > 40 {
            controller.validateFailure(feild: "username", message: "Username can't be longer than 40 characters")
        } else {
            authRepository.login(username: username, password: password) { response in
                
            } failure: { errorMsg in
                
            }

        }
    }
}
