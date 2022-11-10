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

final class NewsRegularCVCell: UICollectionViewCell, NewsViewModelProtocol {
    
    // MARK: -
    static let cellID = "regularCell"
    private let disposeBag = DisposeBag()
    
    public var newsViewModel: NewsViewModel! {
        didSet { configureCell(with: newsViewModel) }
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
    
    private let titlesStackView     = UIStackView()
    private let newsImageView       = UIImageView()
    private let newsSectionLabel    = UILabel()
    private let newsTitleLabel      = UILabel()
    
    private let detailsStackView    = UIStackView()
    private let newsDateLabel       = UILabel()
    private let newsAuthorLabel     = UILabel()
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureImageStackView()
        configureMainStackView()
        configureNewsImageView()
        configureTitlesStackView()
        configureNewsSectionLabel()
        configureNewsTitleLabel()
        configureDetailsStackView()
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
            [self.titlesStackView, self.detailsStackView].forEach {
                $0.backgroundColor      = .quaternarySystemFill
                $0.layer.cornerRadius   = 17
                $0.layer.cornerCurve    = .continuous
            }
        case false:
            [self.titlesStackView, self.detailsStackView].forEach {
                $0.backgroundColor      = .clear
                $0.layer.cornerRadius   = 0
                $0.layer.cornerCurve    = .continuous
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
    
    override func prepareForReuse() {
        self.newsImageView.image    = nil
        self.newsTitleLabel.text    = nil
        self.newsDateLabel.text     = nil
        self.newsAuthorLabel.text   = nil
    }
    
    // MARK: -
    private func configure() {
        self.backgroundColor    = Project.Color.cellBackground
        self.layer.configure(cornerRadius: 23, setShadow: true)
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
        
        mainStackView.distribution  = .equalCentering
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
    
    private func configureTitlesStackView() {
        self.mainStackView.addArrangedSubview(titlesStackView)
        self.titlesStackView.axis = .vertical
    }
    
    private func configureNewsImageView() {
        self.imageStackView.addArrangedSubview(newsImageView)
        newsImageView.clipsToBounds         = true
        newsImageView.layer.masksToBounds   = true
        newsImageView.contentMode           = .scaleAspectFit
        newsImageView.tintColor             = .quaternarySystemFill
        newsImageView.image                 = Project.Image.placeholderImage
    }
    
    private func configureNewsSectionLabel() {
        self.titlesStackView.addArrangedSubview(newsSectionLabel)
        self.titlesStackView.setCustomSpacing(3, after: newsSectionLabel)
        
        self.newsSectionLabel.configureWith(fontSize: 15, fontWeight: .bold, titleColor: .secondaryLabel)
        self.newsSectionLabel.text = " "
    }
    
    private func configureNewsTitleLabel() {
        self.titlesStackView.addArrangedSubview(newsTitleLabel)
        self.titlesStackView.setCustomSpacing(5, after: newsSectionLabel)
        
        newsTitleLabel.configureWith(numberOfLines: 2)
        newsTitleLabel.configureWith(fontSize: 20, fontWeight: .bold)
        newsTitleLabel.text = " "
    }
    
    private func configureDetailsStackView() {
        self.mainStackView.addArrangedSubview(detailsStackView)
        self.detailsStackView.axis = .vertical
    }
    
    private func configureDateLabel() {
        self.detailsStackView.addArrangedSubview(newsDateLabel)
        self.detailsStackView.setCustomSpacing(20, after: newsTitleLabel)
        
        newsDateLabel.configureWith(fontSize: 15, fontWeight: .medium, titleColor: .secondaryLabel)
        newsDateLabel.text = " "
    }
    
    private func configureNewsAuthorLabel() {
        self.detailsStackView.addArrangedSubview(newsAuthorLabel)
        
        newsAuthorLabel.configureWith(fontSize: 13, fontWeight: .regular, titleColor: .secondaryLabel)
        newsAuthorLabel.text = " "
    }

}
