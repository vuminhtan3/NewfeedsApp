//
//  RegisterViewController.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 03/06/2023.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var usernameFailureLb: UILabel!
    @IBOutlet weak var passwordFailureLb: UILabel!
    @IBOutlet weak var confirmPasswordFailureLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameFailureLb.text = ""
        passwordFailureLb.text = ""
        confirmPasswordFailureLb.text = ""
        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if usernameTF.text == "" {
            usernameFailureLb.text = "Username is required"
        } else {
            usernameFailureLb.text = ""
        }
        
        if passwordTF.text == "" {
            passwordFailureLb.text = "Password is required"
        } else if passwordTF.text!.count < 6 {
            passwordFailureLb.text = "Password must be at least 6 character"
        } else {
            passwordFailureLb.text = ""
        }
        
        if passwordTF.text != confirmPasswordTF.text || confirmPasswordTF.text == "" {
            confirmPasswordFailureLb.text = "Password are not matching"
        } else {
            confirmPasswordFailureLb.text = ""
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
