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
        let viewController = NewsVC(collectionViewLayout: UICollectionViewLayout())
        viewController.coordinator = self
        viewController.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper.fill"), tag: 0)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showFullArticle(for url: URL?) {
        guard let url = url else { return }
        
        let safariVC = SFSafariViewController(url: url)
        
        DispatchQueue.main.async {
            self.navigationController.present(safariVC, animated: true)
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: "Error", message: "No connection", preferredStyle: .actionSheet)
        let closeAction = UIAlertAction(title: "Close", style: .default) { _ in
            alertVC.dismiss(animated: true)
        }
        alertVC.addAction(closeAction)
        
        DispatchQueue.main.async {
            self.navigationController.present(alertVC, animated: true)
        }
        
        let image = UIImage().cgImage
        let bitmap = image?.bitmapInfo
    }
}
