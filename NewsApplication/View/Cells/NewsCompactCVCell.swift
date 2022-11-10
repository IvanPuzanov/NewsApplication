//
//  NewsCompactCVCell.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 21.08.2022.
//

import UIKit
import RxSwift

final class NewsCompactCVCell: UICollectionViewCell, NewsViewModelProtocol {
    
    // MARK: -
    static let cellID = "compactCell"
    private let disposeBag = DisposeBag()
    
    public var newsViewModel: NewsViewModel! {
        didSet {
            configureCell(with: newsViewModel)
        }
    }
    
    override var isHighlighted: Bool {
        didSet { cellDidHighlight() }
    }
    
    override var isSelected: Bool {
        didSet { cellDidSelect() }
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
    private func cellDidHighlight() {
        switch isHighlighted {
        case true:
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                self.backgroundColor = .quaternarySystemFill
                self.transform       = CGAffineTransform(scaleX: 0.97, y: 0.97)
            }
        case false:
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                self.backgroundColor = .clear
                self.transform       = .identity
            }
        }
    }
    
    private func cellDidSelect() {
        switch isSelected {
        case true:
            let tapFeedback = UISelectionFeedbackGenerator()
            tapFeedback.prepare()
            tapFeedback.selectionChanged()
        default:
            break
        }
    }
    
    private func configureCell(with newsViewModel: NewsViewModel) {
        switch newsViewModel.isPlaceholder {
        case true:
            [self.newsSectionLabel, self.newsTitleLabel, self.newsDateLabel].forEach {
                $0.backgroundColor      = .quaternarySystemFill
                $0.layer.cornerRadius   = 10
                $0.layer.cornerCurve    = .continuous
            }
        case false:
            [self.newsSectionLabel, self.newsTitleLabel, self.newsDateLabel].forEach {
                $0.backgroundColor      = .clear
                $0.layer.cornerRadius   = 0
                $0.layer.cornerCurve    = .continuous
            }
            
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
    
    override func prepareForReuse() {
        self.newsImageView.image    = nil
        self.newsTitleLabel.text    = nil
        self.newsDateLabel.text     = nil
    }
    
    // MARK: -
    private func configure() {
        self.layer.cornerRadius = 23
        self.layer.cornerCurve  = .continuous
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
        newsImageView.image                 = Project.Image.placeholderImage
        
        NSLayoutConstraint.activate([
            self.newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            self.newsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.newsImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 12/14),
            self.newsImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 12/14)
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
        self.newsSectionLabel.text = " "
    }
    
    private func configureNewsTitleLabel() {
        self.mainStackView.addArrangedSubview(newsTitleLabel)
        self.mainStackView.setCustomSpacing(2, after: newsSectionLabel)
        
        newsTitleLabel.numberOfLines                = 3
        newsTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        newsTitleLabel.text = " "
    }
    
    private func configureDateLabel() {
        self.mainStackView.addArrangedSubview(newsDateLabel)
        self.mainStackView.setCustomSpacing(10, after: newsTitleLabel)
        
        newsDateLabel.adjustsFontSizeToFitWidth    = true
        newsDateLabel.minimumScaleFactor           = 0.7
        newsDateLabel.numberOfLines                = 2
        newsDateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        newsDateLabel.textColor = .secondaryLabel
        newsDateLabel.text = " "
    }
}
