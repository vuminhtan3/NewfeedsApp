//
//  LoginViewController.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 03/06/2023.
//

import UIKit

protocol LoginDisplay {
    func validateFailure(feild: String, message: String)
}

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!

    @IBOutlet weak var passwordFailureLb: UILabel!
    @IBOutlet weak var usernameFailureLb: UILabel!
    var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        /**
         Initialize an instance of AuthAPIService
         */
        let authAPIService = AuthAPIServiceImpl()
        
        /**
         Initialize an instance of AuthRepository
         */
        let authRepository = AuthRepositoryImpl(authAPIService: authAPIService)
        
        presenter = LoginPresenterImpl(controller: self, authRepository: authRepository)
        
        usernameFailureLb.isHidden = true
        passwordFailureLb.isHidden = true
        
        super.viewDidLoad()
        
    }
    
    
    @IBAction func handleUsernameTFChanging(_ sender: UITextField) {
        usernameFailureLb.isHidden = true
        passwordFailureLb.isHidden = true
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
//        if usernameTF.text == "" {
//            usernameFailureLb.text = "Username is required"
//        } else {
//            usernameFailureLb.text = ""
//        }
//
//        if passwordTF.text == "" {
//            passwordFailureLb.text = "Password is required"
//        } else {
//            passwordFailureLb.text = ""
//        }
        let username = usernameTF.text ?? ""
        let password = passwordTF.text ?? ""
        presenter.login(username: username, password: password)
        
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        
    }
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        
    }
    
    private func routeToMain() {
        //Chuyển tới màn hình chính
    }
    
    private func routeToRegister() {
        //
    }
}

extension LoginViewController: LoginDisplay {
    
    func loginSuccess() {
        routeToMain()
    }
    
    func validateFailure(feild: String, message: String) {
        if feild == "username" {
            usernameFailureLb.isHidden = false
            usernameFailureLb.text = message
        } else {
            passwordFailureLb.isHidden = false
            passwordFailureLb.text = message
        }
    }
}
