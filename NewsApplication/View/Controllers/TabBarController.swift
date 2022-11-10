//
//  TabBarController.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import UIKit

final class TabBarController: UITabBarController {

    private let newsCoordinator = NewsCoordinator(UINavigationController())
    private let profileCoordinator = ProfileCoordinator(UINavigationController())
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        newsCoordinator.start()
        profileCoordinator.start()
        
        UITabBar.appearance().tintColor = UIColor(named: "tabBarSelected")
        
        viewControllers = [newsCoordinator.navigationController, profileCoordinator.navigationController]
    }

}
