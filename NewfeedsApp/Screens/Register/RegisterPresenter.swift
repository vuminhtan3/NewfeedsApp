//
//  RegisterPresenter.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 08/06/2023.
//

import Foundation

protocol RegisterPresenter {
    func register(username: String, nickname: String, password: String, confirmPassword: String)
}

class RegisterPresenterImpl: RegisterPresenter {
    
    var registerVC: RegisterDisplay
    var authRepository: AuthRepository

    init(registerVC: RegisterDisplay, authRepository: AuthRepository) {
        self.registerVC = registerVC
        self.authRepository = authRepository
    }
    
    private func validateForm(username: String, password: String, confirmPassword: String) -> Bool {
        var isValid = true
        
        if username.isEmpty {
            isValid = false
            self.registerVC.registerValidateFailure(field: .username, message: "Username is required")
        } else if username.count < 4 {
            isValid = false
            registerVC.registerValidateFailure(field: .username, message: "Username must be at least 4 characters")
        } else if username.count > 40 {
            isValid = false
            registerVC.registerValidateFailure(field: .username, message: "Username can't be longer than 40 characters")
        } else {
            let usernameValidator = UsernameValidator(username: username)
            let isUsernameValid = usernameValidator.isValid()
            if !isUsernameValid {
                isValid = false
                registerVC.registerValidateFailure(field: .username, message: "Username invalid")
            }
        }
        //Check validate password
        if password.isEmpty {
            isValid = false
            registerVC.registerValidateFailure(field: .password, message: "Password is required")
        } else if password.count < 6 {
            isValid = false
            registerVC.registerValidateFailure(field: .password, message: "Password must be at least 6 characters")
        } else if password.count > 40 {
            isValid = false
            registerVC.registerValidateFailure(field: .password, message: "Password can't be longer than 40 characters")
        } else {
            let passwordValidator = PasswordValidator(password: password)
            let isPasswordValid = passwordValidator.isValid()
            
            if !isPasswordValid {
                isValid = false
                registerVC.registerValidateFailure(field: .password, message: "Password invalid")
            }
        }
        
        if confirmPassword.isEmpty {
            isValid = false
            registerVC.registerValidateFailure(field: .confirmPassword, message: "Confirm password is required")
        } else if confirmPassword != password {
            isValid = false
            registerVC.registerValidateFailure(field: .confirmPassword, message: "Password do not match")
        }
        return isValid
    }
    
    
    
    func register(username: String, nickname: String, password: String, confirmPassword: String) {
        let isValid = validateForm(username: username, password: password, confirmPassword: confirmPassword)
        
        guard isValid else {return}
        
        registerVC.showLoading(isShow: true)
        
        authRepository.register(username: username, nickname: nickname, password: password, confirmPassword: confirmPassword) { [weak self] registerEntity in
            guard let self = self else {return}
            self.registerVC.showLoading(isShow: false)
            if let accessToken = registerEntity.accessToken, !accessToken.isEmpty {
                self.registerVC.registerSuccess()
            } else {
                self.registerVC.registerFailure(errorMsg: "Something went wrong!")
            }
        } failure: { [weak self] apiError in
            guard let self = self else {return}
            self.registerVC.showLoading(isShow: false)
            self.registerVC.registerFailure(errorMsg: apiError?.errorMsg ?? "Something went wrong!")
        }
    }
}
