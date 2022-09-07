//
//  NewsRegularCVCell.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import UIKit
import RxSwift

protocol NewsViewModelProtocol {
    var newsViewModel: NewsViewModel! { get set }
}

class NewsRegularCVCell: UICollectionViewCell, NewsViewModelProtocol {
    
    // MARK: -
    static let cellID = "regularCell"
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
    private let imageStackView      = UIStackView()
    private let mainStackView       = UIStackView()
    private let newsImageView       = UIImageView()
    private let newsSectionLabel    = UILabel()
    private let newsTitleLabel      = UILabel()
    private let newsDateLabel       = UILabel()
    private let newsAuthorLabel     = UILabel()
    
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
        configureNewsAuthorLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    private func cellDidHighlight() {
        switch isHighlighted {
        case true:
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                self.transform              = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.layer.shadowOpacity    = 0.2
            }
        case false:
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                self.transform              = .identity
                self.layer.shadowOpacity    = 0.1
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
                $0.backgroundColor = .quaternarySystemFill
            }
        case false:
            [self.newsSectionLabel, self.newsTitleLabel, self.newsDateLabel, self.imageStackView].forEach {
                $0.backgroundColor = .clear
            }
            
            self.newsSectionLabel.text  = newsViewModel.section.uppercased()
            self.newsTitleLabel.text    = newsViewModel.title
            self.newsDateLabel.text     = newsViewModel.date
            self.newsAuthorLabel.text   = newsViewModel.author
            
            self.newsViewModel.image.subscribe { image in
                DispatchQueue.main.async {
                    self.newsImageView.image        = image
                    self.newsImageView.contentMode  = .scaleAspectFill
                }
            } onError: { _ in }.disposed(by: disposeBag)
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
        newsImageView.image                 = UIImage(systemName: "photo.fill")
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
        
        newsTitleLabel.numberOfLines                = 2
        newsTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    private func configureDateLabel() {
        self.mainStackView.addArrangedSubview(newsDateLabel)
        self.mainStackView.setCustomSpacing(20, after: newsTitleLabel)
        
        newsDateLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        newsDateLabel.textColor = .secondaryLabel
    }
    
    private func configureNewsAuthorLabel() {
        self.mainStackView.addArrangedSubview(newsAuthorLabel)
        
        newsAuthorLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        newsAuthorLabel.textColor = .secondaryLabel
    }

}
