//
//  UpdateProfileViewController.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 26/06/2023.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var nickNameTF: UITextField!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var bioTextView: UITextView!
    
    var delegate: ProfileDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor.lightGray.cgColor
        // Do any additional setup after loading the view.
    }
    
    @IBAction func maleBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func femaleBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func updateBtnTapped(_ sender: UIButton) {
        delegate?.passString(str: "abcd")
        
    }
    
}
