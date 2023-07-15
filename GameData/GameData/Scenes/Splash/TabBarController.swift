//
//  TabBarController.swift
//  GameData
//
//  Created by Baki Uçan on 12.07.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeViewController = HomeViewController()
        let favoritesViewController = FavoritesViewController()

        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)

        let viewControllers = [homeViewController, favoritesViewController]
        self.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }

        customizeTabBarAppearance()
    }

    func customizeTabBarAppearance() {
        tabBar.barTintColor = UIColor.white

        tabBar.tintColor = UIColor.red

        tabBar.unselectedItemTintColor = UIColor.gray

        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
}
