//
//  ProfileView.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 06.09.2022.
//

import UIKit

class ProfileView: UIView {

    // MARK: -
    private let profileViewModel = ProfileViewModel()
    
    private let imageView       = UIImageView()
    private let titlesStackView = UIStackView()
    private let nameLabel       = UILabel()
    private let jobLabel        = UILabel()
    private let locationLabel   = UILabel()
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureImageView()
        configureTitlesStackView()
        configureNameLabel()
        configureJobLabel()
        configureLocationLabel()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    private func bind() {
        self.imageView.image    = profileViewModel.profileImage
        self.nameLabel.text     = profileViewModel.profileName
        self.jobLabel.text      = profileViewModel.profileJob
        self.locationLabel.text = profileViewModel.profileLocation
    }
    
    // MARK: -
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureImageView() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode    = .scaleAspectFit
        imageView.image          = UIImage(named: "myMemoji")
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 130),
            imageView.widthAnchor.constraint(equalToConstant: 130),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTitlesStackView() {
        self.addSubview(titlesStackView)
        titlesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        titlesStackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            titlesStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titlesStackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titlesStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func configureNameLabel() {
        self.titlesStackView.addArrangedSubview(nameLabel)
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .label
    }
    
    private func configureJobLabel() {
        self.titlesStackView.addArrangedSubview(jobLabel)
        
        jobLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        jobLabel.textColor = .secondaryLabel
    }
    
    private func configureLocationLabel() {
        self.titlesStackView.addArrangedSubview(locationLabel)
        self.titlesStackView.setCustomSpacing(10, after: jobLabel)
        
        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        locationLabel.textColor = .secondaryLabel
    }
}
