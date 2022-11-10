//
//  NewsCoordinator.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import UIKit
import SafariServices

final class NewsCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Initialization
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// Start coordinator
    func start() {
        let viewController          = NewsVC(collectionViewLayout: UICollectionViewLayout())
        viewController.coordinator  = self
        viewController.tabBarItem   = UITabBarItem(title: Project.Strings.newsTitle, image: Project.Image.newspaperImage, tag: 0)
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    /// Show safari view controller
    /// - Parameter url: Article link
    func showFullArticle(for url: URL?) {
        guard let url = url else { return }
        
        let safariVC = SFSafariViewController(url: url)
        
        DispatchQueue.main.async {
            self.navigationController.present(safariVC, animated: true)
        }
    }
    
    /// Display error alert
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    func showErrorAlert(title: String = "Error", message: String = "Something went wrong") {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let closeAction = UIAlertAction(title: "Close", style: .default) { _ in
            alertVC.dismiss(animated: true)
        }
        alertVC.addAction(closeAction)
        
        DispatchQueue.main.async {
            self.navigationController.present(alertVC, animated: true)
        }
    }
}
