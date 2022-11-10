//
//  NewsSectionCVCell.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import Foundation
import UIKit

final class NewsSectionCVCell: UICollectionViewCell {
    
    // MARK: -
    static let cellID = "sectionCell"

    public var sectionTitle: String! {
        didSet {
            self.sectionTitleLabel.text = sectionTitle.capitalized
        }
    }
    
    override var isSelected: Bool {
        didSet {
            cellSelected()
        }
    }
    
    // MARK: -
    private let sectionTitleLabel = UILabel()
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureSectionTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    private func cellSelected() {
        switch isSelected {
        case true:
            sectionTitleLabel.textColor = .label
            
            let tapFeedback = UISelectionFeedbackGenerator()
            tapFeedback.prepare()
            tapFeedback.selectionChanged()
        case false:
            sectionTitleLabel.textColor = .secondaryLabel
        }
    }
    
    // MARK: -
    private func configure() {
        self.backgroundColor = .systemBackground
    }
    
    private func configureSectionTitleLabel() {
        self.addSubview(sectionTitleLabel)
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sectionTitleLabel.textAlignment = .center
        sectionTitleLabel.textColor     = .secondaryLabel
        sectionTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        NSLayoutConstraint.activate([
            sectionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
