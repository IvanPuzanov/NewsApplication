//
//  ProfileView.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 06.09.2022.
//

import UIKit

final class ProfileView: UIControl {

    // MARK: -
    private let profileViewModel = ProfileViewModel()
    
    private let imageView       = UIImageView()
    private let titlesStackView = UIStackView()
    private let nameLabel       = UILabel()
    private let jobLabel        = UILabel()
    private let locationLabel   = UILabel()
    
    override var isHighlighted: Bool {
        didSet { viewDidHighlight() }
    }
    
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
    
    private func viewDidHighlight() {
        switch isHighlighted {
        case true:
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                self.transform              = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.layer.shadowOpacity    = 0.2
            }
            
            let tapFeedback = UISelectionFeedbackGenerator()
            tapFeedback.prepare()
            tapFeedback.selectionChanged()
        case false:
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                self.transform              = .identity
                self.layer.shadowOpacity    = 0.1
            }
        }
    }
    
    // MARK: -
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor    = UIColor(named: "cellBackground")
        self.layer.cornerRadius = 23
        self.layer.cornerCurve  = .continuous
        
        self.layer.shadowColor      = UIColor.black.cgColor
        self.layer.shadowOffset     = CGSize(width: 0, height: 0)
        self.layer.shadowRadius     = 10
        self.layer.shadowOpacity    = 0.1
    }
    
    private func configureImageView() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode    = .scaleAspectFit
        imageView.image          = UIImage(named: "myMemoji")
        imageView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            imageView.heightAnchor.constraint(equalToConstant: 130),
            imageView.widthAnchor.constraint(equalToConstant: 130),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13)
        ])
    }
    
    private func configureTitlesStackView() {
        self.addSubview(titlesStackView)
        titlesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        titlesStackView.axis = .vertical
        titlesStackView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            titlesStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titlesStackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titlesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13)
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
