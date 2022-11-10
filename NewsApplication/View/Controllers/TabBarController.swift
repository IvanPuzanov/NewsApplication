//
//  TabBarController.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Coordinators
    private let newsCoordinator = NewsCoordinator(UINavigationController())
    private let profileCoordinator = ProfileCoordinator(UINavigationController())
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCoordinators()
        configure()
    }
    
    // MARK: - Handle methods
    private func startCoordinators() {
        newsCoordinator.start()
        profileCoordinator.start()
    }
    
    // MARK: - Configuring methods
    private func configure() {
        viewControllers = [newsCoordinator.navigationController, profileCoordinator.navigationController]
        UITabBar.appearance().tintColor = Project.Color.tabBarSelected
    }

}
