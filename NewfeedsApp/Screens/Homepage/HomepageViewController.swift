//
//  HomepageViewController.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 09/06/2023.
//

import UIKit
import MBProgressHUD

class HomepageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.showLoading(isShow: true)
        AuthService.share.clearAll()
        routeToLogin()
    }
    private func routeToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
//        navigationController?.popToRootViewController(animated: true)
        let nav = UINavigationController(rootViewController: loginVC)
        
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else {return}
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
