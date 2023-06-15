//
//  TutorialViewController.swift
//  PostApp
//
//  Created by Minh Tan Vu on 31/05/2023.
//

import UIKit

private let reuseIdentifier = "TutorialCollectionViewCell"

struct Tutorial {
    let image: String
    let title: String
    let desc: String
}

class TutorialViewController: UIViewController {
    
    @IBOutlet weak private var collectionView: UICollectionView!
    
    private var dataSource = [Tutorial]()
    private var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        dataSource = [
            Tutorial(image: "tutorial2", title: "Welcome to Techmaster", desc: "Học là có việc!"),
            Tutorial(image: "tutorial6", title: "Lớp iOS nâng cao - iOS 08", desc: "Học vì đam mê!"),
            Tutorial(image: "tutorial5", title: "Nâng cao giá trị bản thân", desc: "Hãy làm những gì mình thích!")
        ]
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Đăng ký custom collection view cell
        collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
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
    
    //Hàm chuyển màn sang register và login
    private func routeToAuthNavigation() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "loginVC")
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

//MARK: - UICollectionViewDataSource:
extension TutorialViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TutorialCollectionViewCell
        let tutorialModel = dataSource[indexPath.row]
        
        cell.bindData(index: indexPath.row,
                      imageName: tutorialModel.image,
                      title: tutorialModel.title,
                      desc: tutorialModel.desc) { [weak self] in
            guard let self = self else {return}
            
            if indexPath.row + 1 == self.dataSource.count {
                UserDefaultsSingleton.shared.completedTutorial = true
                
                self.routeToAuthNavigation()
//                print("index: \(indexPath.row), currentPage: \(self.currentPage)")
            } else {
                self.currentPage = indexPath.row + 1
                self.collectionView.isPagingEnabled = false
                self.collectionView.scrollToItem(at: IndexPath(row: self.currentPage, section: 0), at: .centeredHorizontally, animated: true)
                self.collectionView.isPagingEnabled = true
//                print("index: \(indexPath.row), currentPage: \(self.currentPage)")
            }
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate:
extension TutorialViewController: UICollectionViewDelegate {
    
}
