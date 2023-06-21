//
//  LoginViewController.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 03/06/2023.
//

import UIKit
import MBProgressHUD

protocol LoginDisplay {
    func loginSuccess()
    func loginValidateFailure(field: LoginFormField, message: String)
    func loginFailure(errorMsg: String?)
    func showLoading(isShow: Bool)
}

enum LoginFormField {
    case username
    case password
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
        
        presenter = LoginPresenterImpl(loginVC: self, authRepository: authRepository)
        
        usernameFailureLb.isHidden = true
        passwordFailureLb.isHidden = true
        
        super.viewDidLoad()
        
    }
    
    @IBAction func handleTextFieldChanging(_ sender: Any) {
        usernameFailureLb.isHidden = true
        passwordFailureLb.isHidden = true
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let username = usernameTF.text ?? ""
        let password = passwordTF.text ?? ""
        presenter.login(username: username, password: password)
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        
    }
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        routeToRegister()
    }
    
    private func routeToMain() {
        //Chuyển tới màn hình chính
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarVC = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarViewController")
        navigationController?.pushViewController(mainTabBarVC, animated: true)
        
    }
    
    private func routeToRegister() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = mainStoryboard.instantiateViewController(withIdentifier: "RegisterViewController")
        navigationController?.pushViewController(registerVC, animated: true)
        
    }
}

extension LoginViewController: LoginDisplay {
    func loginValidateFailure(field: LoginFormField, message: String) {
        switch field {
        case .username:
            usernameFailureLb.isHidden = false
            usernameFailureLb.text = message
        case .password:
            passwordFailureLb.isHidden = false
            passwordFailureLb.text = message
        }
    }
    
    func loginSuccess() {
        routeToMain()
        
    }

    func loginFailure(errorMsg: String?) {
        let alert = UIAlertController(title: "Login failure", message: errorMsg ?? "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
