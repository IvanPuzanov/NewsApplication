//
//  ViewController.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import UIKit
import RxSwift
import RxCocoa

class NewsVC: UIViewController {

    // MARK: -
    public var coordinator: NewsCoordinator?
    private var newsCollectionView: NewsCollectionView!
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootView()
        configureCollectionView()
    }
    
    // MARK: -
    private func configureRootView() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "News"
    }

    private func configureCollectionView() {
        newsCollectionView = NewsCollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewLayout())
        newsCollectionView.coordinator = coordinator
        self.view.addSubview(newsCollectionView)
        
        NSLayoutConstraint.activate([
            newsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            newsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

