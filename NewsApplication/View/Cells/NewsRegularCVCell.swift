//
//  NewsRegularCVCell.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import UIKit
import RxSwift

class NewsRegularCVCell: UICollectionViewCell {
    
    // MARK: -
    static let cellID = "regularCell"
    
    public var newsViewModel: NewsViewModel! {
        didSet {
            self.newsSectionLabel.text  = newsViewModel.section.uppercased()
            self.newsTitleLabel.text    = newsViewModel.title
            self.newsDateLabel.text     = newsViewModel.date
            
            self.newsViewModel.image.subscribe { image in
                self.newsImageView.contentMode = .scaleAspectFill
                self.newsImageView.image = image
            } onError: { error in
                print(error)
            }.disposed(by: DisposeBag())

        }
    }
    
    // MARK: -
    private let imageStackView      = UIStackView()
    private let mainStackView       = UIStackView()
    private let newsImageView       = UIImageView()
    private let newsSectionLabel    = UILabel()
    private let newsTitleLabel      = UILabel()
    private let newsDateLabel       = UILabel()
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureImageStackView()
        configureMainStackView()
        configureNewsImageView()
        configureNewsSectionLabel()
        configureNewsTitleLabel()
        configureDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func configureImageStackView() {
        self.addSubview(imageStackView)
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        
        imageStackView.axis             = .vertical
        imageStackView.clipsToBounds    = true
        imageStackView.layer.cornerRadius   = 23
        imageStackView.layer.cornerCurve    = .continuous
        imageStackView.layer.maskedCorners  = CACornerMask([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        imageStackView.layer.masksToBounds  = true
        
        NSLayoutConstraint.activate([
            imageStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageStackView.topAnchor.constraint(equalTo: topAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageStackView.heightAnchor.constraint(equalToConstant: 210)
        ])
    }
    
    private func configureMainStackView() {
        self.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.axis          = .vertical
        mainStackView.clipsToBounds = true
        
        let padding: CGFloat = 13
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            mainStackView.topAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: 11),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    private func configureNewsImageView() {
        self.imageStackView.addArrangedSubview(newsImageView)
        newsImageView.clipsToBounds         = true
        newsImageView.layer.masksToBounds   = true
        newsImageView.contentMode           = .scaleAspectFit
        newsImageView.tintColor             = .quaternarySystemFill
    }
    
    private func configureNewsSectionLabel() {
        self.mainStackView.addArrangedSubview(newsSectionLabel)
        self.mainStackView.setCustomSpacing(3, after: newsSectionLabel)
        
        self.newsSectionLabel.textColor = .secondaryLabel
        self.newsSectionLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    private func configureNewsTitleLabel() {
        self.mainStackView.addArrangedSubview(newsTitleLabel)
        self.mainStackView.setCustomSpacing(5, after: newsSectionLabel)
        
        newsTitleLabel.adjustsFontSizeToFitWidth    = true
        newsTitleLabel.minimumScaleFactor           = 0.7
        newsTitleLabel.numberOfLines                = 2
        newsTitleLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
    }
    
    private func configureDateLabel() {
        self.mainStackView.addArrangedSubview(newsDateLabel)
        self.mainStackView.setCustomSpacing(20, after: newsTitleLabel)
        
        newsDateLabel.adjustsFontSizeToFitWidth    = true
        newsDateLabel.minimumScaleFactor           = 0.7
        newsDateLabel.numberOfLines                = 2
        newsDateLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        newsDateLabel.textColor = .secondaryLabel
    }

}
