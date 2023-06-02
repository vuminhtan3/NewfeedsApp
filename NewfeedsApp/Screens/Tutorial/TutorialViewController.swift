//
//  TutorialViewController.swift
//  PostApp
//
//  Created by Minh Tan Vu on 31/05/2023.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet weak private var collectionView: UICollectionView!
    let images = [UIImage(named: "tutorial2"), UIImage(named: "tutorial6"), UIImage(named: "tutorial5")]
    let titles = ["Welcome to Techmaster", "Lớp iOS nâng cao - iOS 08", "Nâng cao giá trị bản thân"]
    let des = ["Học là có việc!", "Học vì đam mê!", "Hãy làm những gì mình thích!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Đăng ký custom collection view cell
        let cellID = "TutorialCollectionViewCell"
        let nib = UINib(nibName: cellID, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .white
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            
            flowLayout.estimatedItemSize = .zero
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            flowLayout.scrollDirection = .horizontal
        }
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
}

extension TutorialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionViewCell", for: indexPath) as! TutorialCollectionViewCell
        
        cell.tutorialImage.image = images[indexPath.row]
        cell.titleLabel.text = titles[indexPath.row]
        cell.desLabel.text = des[indexPath.row]
        if indexPath.row < images.count - 1 {
            cell.skipBtn.setTitle("Skip", for: .normal)
            cell.skipButtonPressed(UIButton())
        } else {
            cell.skipBtn.setTitle("Start", for: .normal)
        }
        
        return cell
    }
    
    
}

extension TutorialViewController: UICollectionViewDelegate {
    
}
