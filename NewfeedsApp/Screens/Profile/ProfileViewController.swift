//
//  ProfileViewController.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 13/06/2023.
//

import UIKit

protocol ProfileDelegate: class {
    func passString(str: String)
}

class ProfileViewController: UIViewController, ProfileDelegate {
    func passString(str: String) {
        print(str)
    }
    

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var nicknameLb: UILabel!
    @IBOutlet weak var bioLb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func editAvatarBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func settingBtnTapped(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let updateProfileVC = mainStoryboard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
        updateProfileVC.delegate = self
        navigationController?.pushViewController(updateProfileVC, animated: true)
        navigationController?.isNavigationBarHidden = false
    }
    
}

