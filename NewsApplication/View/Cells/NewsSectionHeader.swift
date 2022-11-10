//
//  NewsSectionHeader.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 12.09.2022.
//

import UIKit

final class NewsSectionHeader: UICollectionReusableView {
    
    // MARK: -
    static let cellID = "sectionHeader"
    public var titleString: String! {
        didSet { self.titleLabel.text = titleString }
    }
    
    private let titleLabel = UILabel()
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    private func configure() {
        let blurEffect                  = UIBlurEffect(style: .regular)
        let blurEffectView              = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame            = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(blurEffectView)
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Top stories"
        titleLabel.configureWith(fontSize: 16, fontWeight: .semibold)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
