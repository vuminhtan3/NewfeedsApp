//
//  TutorialCollectionViewCell.swift
//  PostApp
//
//  Created by Minh Tan Vu on 01/06/2023.
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tutorialImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    
    var skipButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        skipBtn.layer.cornerRadius = 10
        skipBtn.layer.borderWidth = 1.0
        skipBtn.layer.borderColor = UIColor.systemCyan.cgColor
        skipBtn.setTitleColor(UIColor.systemCyan, for: .normal)
        skipBtn.clipsToBounds = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tutorialImage.image = nil
        titleLabel.text = nil
        descLabel.text = nil
    }

    @IBAction func skipButtonPressed(_ sender: UIButton) {
        skipButtonAction?()
    }
    
    func bindData(index: Int, imageName: String, title: String, desc: String, skipButtonAction: (() -> Void)?) {
        
        if index == 2 {
            skipBtn.setTitle("Start", for: .normal)
        } else {
            skipBtn.setTitle("Skip", for: .normal)
        }
        
        self.skipButtonAction = skipButtonAction
        tutorialImage.image = UIImage(named: imageName)
        titleLabel.text = title
        descLabel.text = desc
    }
    
}
