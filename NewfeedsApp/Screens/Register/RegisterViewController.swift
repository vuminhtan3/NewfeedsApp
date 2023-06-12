//
//  RegisterViewController.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 03/06/2023.
//

import UIKit
import MBProgressHUD

protocol RegisterDisplay {
    func registerSuccess()
    func registerValidateFailure(field: RegisterFormField, message: String?)
    func registerFailure(errorMsg: String?)
    func showLoading(isShow: Bool)
    
}

enum RegisterFormField {
    case username
    case password
    case confirmPassword
}

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var usernameFailureLb: UILabel!
    @IBOutlet weak var passwordFailureLb: UILabel!
    @IBOutlet weak var confirmPasswordFailureLb: UILabel!
    
    var presenter: RegisterPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authAPIService = AuthAPIServiceImpl()
        let authRepository = AuthRepositoryImpl(authAPIService: authAPIService)
        presenter = RegisterPresenterImpl(registerVC: self, authRepository: authRepository)
        
        usernameFailureLb.isHidden = true
        passwordFailureLb.isHidden = true
        confirmPasswordFailureLb.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleTextFieldChanging(_ sender: UITextField) {
        usernameFailureLb.isHidden = true
        passwordFailureLb.isHidden = true
        confirmPasswordFailureLb.isHidden = true
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        let username = usernameTF.text ?? ""
        let password = passwordTF.text ?? ""
        let confirmPassword = confirmPasswordTF.text ?? ""
        
        presenter.register(username: username, nickname: username, password: password, confirmPassword: confirmPassword)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension RegisterViewController: RegisterDisplay {
    func registerValidateFailure(field: RegisterFormField, message: String?) {
        switch field {
        case .username:
            usernameFailureLb.isHidden = false
            usernameFailureLb.text = message
        case .password:
            passwordFailureLb.isHidden = false
            passwordFailureLb.text = message
        case .confirmPassword:
            confirmPasswordFailureLb.isHidden = false
            confirmPasswordFailureLb.text = message
        }
    }
   
    func registerSuccess() {
        let alert = UIAlertController(title: "Register Success", message: "Register successfull, go to homepage", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.routeToMain()
        }))
        self.present(alert, animated: true)
        
    }
    
    func registerFailure(errorMsg: String?) {
        let alert = UIAlertController(title: "Register failure", message: errorMsg ?? "Something went wrong", preferredStyle: .alert)
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
    
    private func routeToMain() {
        //Chuyển tới màn hình chính
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homepageVC = mainStoryboard.instantiateViewController(withIdentifier: "homepageVC") as! HomepageViewController
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else {return}
        
        window.rootViewController = homepageVC
        window.makeKeyAndVisible()
        
    }
}
