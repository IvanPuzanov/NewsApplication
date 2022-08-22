//
//  ProfileVC.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import UIKit

class ProfileVC: UIViewController {
    
    public var coordinator: Coordinator?

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        configureRootView()
    }
    
    // MARK: -
    private func configureRootView() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Profile"
    }

}
