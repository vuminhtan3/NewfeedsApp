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
    
    var nextCallback: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        skipBtn.layer.cornerRadius = 10
        skipBtn.layer.borderWidth = 1.0
        skipBtn.layer.borderColor = UIColor.blue.cgColor
        skipBtn.setTitleColor(UIColor.blue, for: .normal)
        skipBtn.clipsToBounds = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tutorialImage.image = nil
        titleLabel.text = nil
        descLabel.text = nil
    }

    @IBAction func skipButtonPressed(_ sender: UIButton) {
       nextCallback?()
    }
    
    func bindData(index: Int, imageName: String, title: String, desc: String, nextCallback: ((_ indexPath: IndexPath) -> Void)?) {
        if index == 2 {
            skipBtn.setTitle("Start", for: .normal)
        } else {
            skipBtn.setTitle("Skip", for: .normal)
        }
        self.nextCallback = {
            nextCallback?(IndexPath(row: index, section: 0))
        }
        tutorialImage.image = UIImage(named: imageName)
        titleLabel.text = title
        descLabel.text = desc
    }
    
}
