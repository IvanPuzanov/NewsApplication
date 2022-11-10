//
//  ProfileVC.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import UIKit
import RxSwift

final class ProfileVC: UIViewController {
    
    // MARK: - Parameters
    public var coordinator: Coordinator?
    private let disposeBag          = DisposeBag()
    private let profileViewModel    = ProfileViewModel()
    
    // MARK: - Views
    private let profileView = ProfileView()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureRootView()
        configureProfileView()
    }
    
    // MARK: - Handle methods
    
    // MARK: - Configuring methods
    private func configureRootView() {
        self.view.backgroundColor   = .systemBackground
        self.title                  = "Profile"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configureProfileView() {
        self.view.addSubview(profileView)
        
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
