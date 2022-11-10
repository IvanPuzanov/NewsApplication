//
//  ProfileInfoView.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 12.09.2022.ч
//

import UIKit

final class ProfileCard: UIControl {

    // MARK: -
    private let stackView       = UIStackView()
    private let titleLabel      = UILabel()
    private let messageLabel    = UILabel()
    
    private var profileInfo: ProfileInfoModel?
    
    override var isHighlighted: Bool {
        didSet { viewDidHighlight() }
    }
    
    // MARK: -
    convenience init(profileInfo: ProfileInfoModel) {
        self.init(frame: .zero)
        
        self.profileInfo = profileInfo
        
        configure()
        configureStackView()
        configureTitleLabel()
        configureMessageLabel()
    }
    
    // MARK: -
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
        self.backgroundColor    = UIColor(named: "cellBackground")
        self.layer.cornerRadius = 23
        self.layer.cornerCurve  = .continuous
        
        self.layer.shadowColor      = UIColor.black.cgColor
        self.layer.shadowOffset     = CGSize(width: 0, height: 0)
        self.layer.shadowRadius     = 10
        self.layer.shadowOpacity    = 0.1
    }
    
    private func configureStackView() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func configureTitleLabel() {
        self.stackView.addArrangedSubview(titleLabel)
        
        titleLabel.font         = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor    = .secondaryLabel
        
        if let title = profileInfo?.title {
            self.titleLabel.text = title
        }
    }
    
    private func configureMessageLabel() {
        self.stackView.addArrangedSubview(messageLabel)
        self.stackView.setCustomSpacing(10, after: titleLabel)
        
        messageLabel.font           = UIFont.systemFont(ofSize: 16, weight: .regular)
        messageLabel.textColor      = .label
        messageLabel.numberOfLines  = 0
        
        if let message = profileInfo?.message {
            self.messageLabel.text = message
        }
    }
    
}
