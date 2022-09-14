//
//  NewsCollectionView.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 26.08.2022.
//

import UIKit
import RxSwift
import RxCocoa

enum Section {
    case section
    case regular
    case compact
}

class NewsCollectionView: UICollectionView {

    public var coordinator: NewsCoordinator?
    
    private var viewModel       = NewsResultViewModel()
    private var disposeBag     = DisposeBag()
    
    private var newsCollectionLayout: UICollectionViewCompositionalLayout!
    private var newsCollectionDataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    private var refreshController = UIRefreshControl()
    
    // MARK: -
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        configure()
        configureLayout()
        configureDataSource()
        configureRefreshController()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinited")
    }
    
    // MARK: -
    private func bind() {
        self.viewModel.loadData()
        
        self.viewModel.newsViewModels.subscribe { viewModels in
            self.updateData(with: viewModels)
        } onError: { error in
            self.coordinator?.showErrorAlert(title: "Error", message: "No connenction")
        }.disposed(by: disposeBag)

        self.rx.itemSelected.subscribe { indexPath in
            switch indexPath.section {
            case 0:
                if let viewModels = self.viewModel.didSelectSection(in: self, at: indexPath) {
                    self.updateData(with: viewModels)
                }
            default:
                if let viewModel = self.viewModel.didSelectNews(in: self, at: indexPath) {
                    self.coordinator?.showFullArticle(for: viewModel.url)
                }
            }
        } onError: { error in }.disposed(by: disposeBag)
    }
    
    private func updateData(with viewModels: [NewsViewModel]) {
        guard !viewModels.isEmpty else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        let news     = viewModel.prepareNews(news: viewModels)
        
        snapshot.appendSections([.section, .regular, .compact])

        snapshot.appendItems(viewModel.newsSections, toSection: .section)
        snapshot.appendItems(news.regular, toSection: .regular)
        snapshot.appendItems(news.compact, toSection: .compact)
        
        DispatchQueue.main.async {
            self.newsCollectionDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc
    private func pullToRefresh() {
        DispatchQueue.main.async {
            self.viewModel.loadData()
            self.refreshController.endRefreshing()
        }
    }
    
    // MARK: -
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints  = false
        self.allowsMultipleSelection                    = true
        
        self.register(NewsSectionCVCell.self, forCellWithReuseIdentifier: NewsSectionCVCell.cellID)
        self.register(NewsRegularCVCell.self, forCellWithReuseIdentifier: NewsRegularCVCell.cellID)
        self.register(NewsCompactCVCell.self, forCellWithReuseIdentifier: NewsCompactCVCell.cellID)
        self.register(NewsSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NewsSectionHeader.cellID)
    }
    
    private func configureLayout() {
        newsCollectionLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            switch section {
            case 0:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(20),
                                                                    heightDimension: .absolute(40)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(20),
                                                                                 heightDimension: .absolute(40)),
                                                               subitems: [item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(16), top: .none, trailing: .fixed(0), bottom: .none)
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
                                                                    heightDimension: .absolute(395)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                             leading: 16,
                                                             bottom: 16,
                                                             trailing: 16)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: widthDimension,
                                                                                 heightDimension: .absolute(395)),
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
                
                if !self.newsCollectionDataSource.snapshot().itemIdentifiers(inSection: .compact).isEmpty {
                    let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(35)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                    headerElement.pinToVisibleBounds = true
                    section.boundarySupplementaryItems = [headerElement]
                }
                
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
    
    private func configureDataSource() {
        newsCollectionDataSource = UICollectionViewDiffableDataSource(collectionView: self, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch indexPath.section {
            case 0:
                guard let sectionString = itemIdentifier as? String else { return UICollectionViewCell() }
                
                if let cell = self.dequeueReusableCell(withReuseIdentifier: NewsSectionCVCell.cellID, for: indexPath) as? NewsSectionCVCell {
                    cell.sectionTitle = sectionString
                    return cell
                }
            case 1:
                guard let viewModel = itemIdentifier as? NewsViewModel else { return UICollectionViewCell() }
                
                if let cell = self.dequeueReusableCell(withReuseIdentifier: NewsRegularCVCell.cellID, for: indexPath) as? NewsRegularCVCell {
                    cell.newsViewModel = viewModel
                    return cell
                }
                break
            case 2:
                guard let viewModel = itemIdentifier as? NewsViewModel else { return UICollectionViewCell() }
                
                if let cell = self.dequeueReusableCell(withReuseIdentifier: NewsCompactCVCell.cellID, for: indexPath) as? NewsCompactCVCell {
                    cell.newsViewModel = viewModel
                    return cell
                }
                break
            default:
                break
            }
            
            return UICollectionViewCell()
        })
        
        newsCollectionDataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            if let cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NewsSectionHeader.cellID, for: indexPath) as? NewsSectionHeader {
                cell.titleString = "Top stories"
                return cell
            }
            return nil
            
        }
    }
    
    private func configureRefreshController() {
        self.refreshController.tintColor = .systemGray
        self.refreshController.addTarget(nil, action: #selector(pullToRefresh), for: .valueChanged)
        self.addSubview(refreshController)
    }
}
