//
//  NewsCompactCVCell.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 21.08.2022.
//

import UIKit
import RxSwift

class NewsCompactCVCell: UICollectionViewCell {
    
    // MARK: -
    static let cellID = "compactCell"
    private let disposeBag = DisposeBag()
    
    public var newsViewModel: NewsViewModel! {
        didSet {
            self.newsSectionLabel.text  = newsViewModel.section.uppercased()
            self.newsTitleLabel.text    = newsViewModel.title
            self.newsDateLabel.text     = newsViewModel.date
            
            self.newsViewModel.image.subscribe { image in
                DispatchQueue.main.async {
                    self.newsImageView.image        = image
                    self.newsImageView.contentMode  = .scaleAspectFill
                }
            } onError: { _ in }.disposed(by: disposeBag)
        }
    }
    
    // MARK: -
    
    private let mainStackView       = UIStackView()
    private let newsSectionLabel    = UILabel()
    private let newsTitleLabel      = UILabel()
    private let newsDateLabel       = UILabel()
    private let newsImageView       = UIImageView()
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureNewsImageView()
        configureMainStackView()
        configureNewsSectionLabel()
        configureNewsTitleLabel()
        configureDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    private func configure() {
//        self.backgroundColor    = UIColor(named: "cellBackground")
//        self.layer.cornerRadius = 23
//        self.layer.cornerCurve  = .continuous
//
//        self.layer.shadowColor      = UIColor.black.cgColor
//        self.layer.shadowOffset     = CGSize(width: 0, height: 0)
//        self.layer.shadowRadius     = 10
//        self.layer.shadowOpacity    = 0.1
    }
    
    private func configureNewsImageView() {
        self.addSubview(newsImageView)
        self.newsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        newsImageView.clipsToBounds         = true
        newsImageView.layer.masksToBounds   = true
        newsImageView.contentMode           = .scaleAspectFit
        newsImageView.tintColor             = .quaternarySystemFill
        newsImageView.layer.cornerRadius    = 15
        newsImageView.layer.cornerCurve     = .continuous
        
        NSLayoutConstraint.activate([
            self.newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            self.newsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.newsImageView.heightAnchor.constraint(equalToConstant: 90),
            self.newsImageView.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func configureMainStackView() {
        self.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.axis          = .vertical
        mainStackView.clipsToBounds = true
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            mainStackView.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -padding),
            mainStackView.centerYAnchor.constraint(equalTo: newsImageView.centerYAnchor)
        ])
    }
    
    private func configureNewsSectionLabel() {
        self.mainStackView.addArrangedSubview(newsSectionLabel)
        
        self.newsSectionLabel.textColor = .secondaryLabel
        self.newsSectionLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    }
    
    private func configureNewsTitleLabel() {
        self.mainStackView.addArrangedSubview(newsTitleLabel)
        self.mainStackView.setCustomSpacing(5, after: newsSectionLabel)
        
        newsTitleLabel.numberOfLines                = 3
        newsTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    private func configureDateLabel() {
        self.mainStackView.addArrangedSubview(newsDateLabel)
        self.mainStackView.setCustomSpacing(10, after: newsTitleLabel)
        
        newsDateLabel.adjustsFontSizeToFitWidth    = true
        newsDateLabel.minimumScaleFactor           = 0.7
        newsDateLabel.numberOfLines                = 2
        newsDateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        newsDateLabel.textColor = .secondaryLabel
    }
}
