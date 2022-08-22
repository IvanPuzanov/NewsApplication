//
//  NewsCoordinator.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//


import UIKit
import SafariServices

class NewsCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: -
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = NewsVC()
        viewController.coordinator = self
        viewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper.fill"), tag: 0)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showFullArticle(for news: NewsViewModel) {
        guard let url = URL(string: news.url) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        navigationController.present(safariVC, animated: true)
    }
    
}
