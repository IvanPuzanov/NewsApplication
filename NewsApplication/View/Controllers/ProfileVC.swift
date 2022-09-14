//
//  ProfileVC.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import UIKit
import RxSwift

class ProfileVC: UICollectionViewController {
    
    public var coordinator: Coordinator?
    private let disposeBag          = DisposeBag()
    private let profileViewModel    = ProfileViewModel()
    

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        configureRootView()
        
        bind()
    }
    
    // MARK: -
    private func bind() {
        

    }
    
    // MARK: -
    private func configureRootView() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
