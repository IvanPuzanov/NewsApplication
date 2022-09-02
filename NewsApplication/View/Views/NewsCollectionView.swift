//
//  NewsCollectionView.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 26.08.2022.
//

import UIKit

class NewsCollectionView: UICollectionView {

    private var newsCollectionLayout: UICollectionViewCompositionalLayout!
    
    // MARK: -
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configure()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.register(NewsSectionCVCell.self, forCellWithReuseIdentifier: NewsSectionCVCell.cellID)
        self.register(NewsRegularCVCell.self, forCellWithReuseIdentifier: NewsRegularCVCell.cellID)
        self.register(NewsCompactCVCell.self, forCellWithReuseIdentifier: NewsCompactCVCell.cellID)
    }
    
    private func configureLayout() {
        newsCollectionLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            switch section {
            case 0:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(80),
                                                                    heightDimension: .absolute(60)))
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .flexible(16),
                                                                 top: .none,
                                                                 trailing: .none,
                                                                 bottom: .none)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .absolute(60)),
                                                               subitems: [item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none,
                                                                  top: .none,
                                                                  trailing: .flexible(16),
                                                                  bottom: .none)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
            case 1:
                var widthDimension: NSCollectionLayoutDimension = .fractionalWidth(1)
                
                switch self.traitCollection.horizontalSizeClass {
                case .regular:
                    widthDimension = .fractionalWidth(1/2)
                case .compact:
                    widthDimension = .fractionalWidth(1)
                default:
                    break
                }
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: widthDimension,
                                                                    heightDimension: .absolute(370)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                             leading: 16,
                                                             bottom: 16,
                                                             trailing: 16)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: widthDimension,
                                                                                 heightDimension: .absolute(370)),
                                                               subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                
                return section
            case 2:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                    heightDimension: .absolute(150)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                             leading: 16,
                                                             bottom: 16,
                                                             trailing: 16)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .absolute(150)),
                                                               subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            default:
                break
            }
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(80), heightDimension: .absolute(60)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        })
        
        self.setCollectionViewLayout(newsCollectionLayout, animated: true)
    }
    
}
