//
//  LoginPresenter.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 05/06/2023.
//

import Foundation
import Dispatch

/**
 Xử lý bussiness login
 */

protocol LoginPresenter {
    func login(username: String, password: String)
}

class LoginPresenterImpl: LoginPresenter {
    
    var loginVC: LoginDisplay
    var authRepository: AuthRepository
    
    init(loginVC: LoginDisplay, authRepository: AuthRepository) {
        self.loginVC = loginVC
        self.authRepository = authRepository
    }
    
    private func validateForm(username: String, password: String) -> Bool {
        var isValid = true
        
        //Check validate username
        if username.isEmpty {
            isValid = false
            loginVC.loginValidateFailure(field: .username, message: "Username is required")
        } else if username.count < 4 {
            isValid = false
            loginVC.loginValidateFailure(field: .username, message: "Username must be at least 4 characters")
        } else if username.count > 40 {
            isValid = false
            loginVC.loginValidateFailure(field: .username, message: "Username can't be longer than 40 characters")
        } else {
            let usernameValidator = UsernameValidator(username: username)
            let isUsernameValid = usernameValidator.isValid()
            if !isUsernameValid {
                isValid = false
                loginVC.loginValidateFailure(field: .username, message: "Username invalid")
            }
        }
        //Check validate password
        if password.isEmpty {
            isValid = false
            loginVC.loginValidateFailure(field: .password, message: "Password is required")
        } else if password.count < 6 {
            isValid = false
            loginVC.loginValidateFailure(field: .password, message: "Password must be at least 6 characters")
        } else if password.count > 40 {
            isValid = false
            loginVC.loginValidateFailure(field: .password, message: "Password can't be longer than 40 characters")
        } else {
            let passwordValidator = PasswordValidator(password: password)
            let isPasswordValid = passwordValidator.isValid()
            
            if !isPasswordValid {
                isValid = false
                loginVC.loginValidateFailure(field: .password, message: "Password invalid")
            }
        }
        return isValid
    }
    
    func login(username: String, password: String) {
        let isValid = validateForm(username: username, password: password)
        
        guard isValid else {return}
        
        loginVC.showLoading(isShow: true)
        authRepository.login(username: username, password: password) { [weak self] loginEntity in
            guard let self = self else {return}
            self.loginVC.showLoading(isShow: false)
            if let accessToken = loginEntity.accessToken, !accessToken.isEmpty {
                self.loginVC.loginSuccess()
            } else {
                self.loginVC.loginFailure(errorMsg: "Something went wrong!")
            }
            
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.loginVC.showLoading(isShow: false)
            self.loginVC.loginFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong!")
        }

    }
}
