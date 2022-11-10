//
//  ProfileCoordinator.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import UIKit

final class ProfileCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Initializtion
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// Start coordinator
    func start() {
        let viewController          = ProfileVC()
        viewController.coordinator  = self
        viewController.tabBarItem   = UITabBarItem(title: Project.Strings.profileTitle, image: Project.Image.personImage, tag: 1)
        
        navigationController.pushViewController(viewController, animated: false)
    }
}
