//
//  MainTabBarViewController.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 13/06/2023.
//

import UIKit
import ESTabBarController_swift

class MainTabBarViewController: ESTabBarController {

    lazy var homeVC: UIViewController = {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homepageVC")
        viewController.tabBarItem = ESTabBarItem(
            CustomStyleTabBarContentView(),
            title: "",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"))
        let nav = AppNavigationController(rootViewController: viewController)
        return nav
    }()
    
    lazy var favouriteVC: UIViewController = {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavouriteViewController")
        viewController.tabBarItem = ESTabBarItem(
            CustomStyleTabBarContentView(),
            title: "",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill"))
        let nav = AppNavigationController(rootViewController: viewController)
        return nav
    }()

    lazy var pinPostVC: UIViewController = {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PinPostViewController")
        viewController.tabBarItem = ESTabBarItem(
            CustomStyleTabBarContentView(),
            title: "",
            image: UIImage(systemName: "pin"),
            selectedImage: UIImage(systemName: "pin.fill"))
        let nav = AppNavigationController(rootViewController: viewController)
        return nav
    }()
    
    lazy var profileVC: UIViewController = {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileVC")
        viewController.tabBarItem = ESTabBarItem(
            CustomStyleTabBarContentView(),
            title: "",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill"))
        let nav = AppNavigationController(rootViewController: viewController)
        return nav
    }()
    
    override func loadView() {
        super.loadView()
        loadTabBarView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().backgroundColor = .clear
        UITabBar.appearance().tintColor = .clear
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedIndex = 0
    }
    
    private func loadTabBarView() {
        setViewControllers([homeVC, favouriteVC, pinPostVC, profileVC], animated: true)
    }
}
