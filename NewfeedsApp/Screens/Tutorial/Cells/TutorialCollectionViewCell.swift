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
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        skipBtn.layer.cornerRadius = 10
        skipBtn.layer.borderWidth = 1.0
        skipBtn.layer.borderColor = UIColor.blue.cgColor
        skipBtn.clipsToBounds = true
        
    }

    @IBAction func skipButtonPressed(_ sender: UIButton) {
        guard let collectionView = superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: self) else {
            return
        }
        
        let nextIndexPath = IndexPath(item: indexPath.row + 1, section: indexPath.section)
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredVertically, animated: true)
    }
    
}
