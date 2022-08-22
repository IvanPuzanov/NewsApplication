//
//  ViewController.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import UIKit
import RxSwift
import RxCocoa

class NewsVC: UIViewController {

    // MARK: -
    enum Section {
        case section
        case regular
        case compact
    }
    
    public var coordinator: NewsCoordinator?
    private var viewModel       = NewsResultViewModel()
    private var newsViewModels  = [NewsViewModel]()
    private var disposeaBag     = DisposeBag()
    
    private var newsCollectionView: UICollectionView!
    private var newsCollectionDataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    private var newsCollectionLayout: UICollectionViewCompositionalLayout!
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootView()
        configureCollectionViewLayout()
        configureCollectionView()
        configureDataSource()
        
        bind()
    }
    
    // MARK: -
    private func bind() {
        viewModel.loadData()
        
        viewModel.newsViewModels.subscribe { viewModels in
            self.newsViewModels = viewModels
            self.updateData(with: viewModels)
        } onError: { error in
            let alertVC = UIAlertController(title: "Ошибка", message: "Что-то пошло не так", preferredStyle: .alert)
            self.coordinator?.navigationController.present(alertVC, animated: true)
        }.disposed(by: disposeaBag)
        
        newsCollectionView.rx.itemSelected.subscribe { indexPath in
            self.itemSelected(for: indexPath)
        } onError: { error in
            print(error)
        }.disposed(by: disposeaBag)
    }
    
    private func itemSelected(for indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                self.updateData(with: self.newsViewModels)
            default:
                if let cell = self.newsCollectionView.cellForItem(at: indexPath) as? NewsSectionCVCell {
                    let filteredViewModels = self.newsViewModels.filter { $0.section.lowercased() == cell.sectionTitle.lowercased() }
                    self.updateData(with: filteredViewModels)
                }
            }
        default:
            break
        }
    }
    
    private func updateData(with viewModels: [NewsViewModel]) {
        guard !viewModels.isEmpty else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapshot.appendSections([.section, .regular, .compact])
        
        var newsSections: [String] = ["All"]
        self.newsViewModels.forEach {
            guard !newsSections.contains($0.section) else { return }
            newsSections.append($0.section)
        }
        
        snapshot.appendItems(newsSections, toSection: .section)
        snapshot.appendItems(Array(viewModels.prefix(upTo: Int(viewModels.count / 2))), toSection: .regular)
        snapshot.appendItems(Array(viewModels.suffix(from: Int(viewModels.count / 2))), toSection: .compact)
        
        DispatchQueue.main.async {
            self.newsCollectionDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    // MARK: -
    private func configureRootView() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "News"
    }
    
    private func configureDataSource() {
        newsCollectionDataSource = UICollectionViewDiffableDataSource(collectionView: newsCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch indexPath.section {
            case 0:
                // Добавить конфигурацию ячейки секции
                guard let sectionString = itemIdentifier as? String else { return UICollectionViewCell() }
                
                if let cell = self.newsCollectionView.dequeueReusableCell(withReuseIdentifier: NewsSectionCVCell.cellID, for: indexPath) as? NewsSectionCVCell {
                    cell.sectionTitle = sectionString
                    return cell
                }
            case 1:
                // Добавить конфигурацию регулярной ячейки новости
                guard let viewModel = itemIdentifier as? NewsViewModel else { return UICollectionViewCell() }
                
                if let cell = self.newsCollectionView.dequeueReusableCell(withReuseIdentifier: NewsRegularCVCell.cellID, for: indexPath) as? NewsRegularCVCell {
                    cell.newsViewModel = viewModel
                    return cell
                }
                break
            case 2:
                // Добавить конфигурацию компактной ячейки новости
                guard let viewModel = itemIdentifier as? NewsViewModel else { return UICollectionViewCell() }
                
                if let cell = self.newsCollectionView.dequeueReusableCell(withReuseIdentifier: NewsCompactCVCell.cellID, for: indexPath) as? NewsCompactCVCell {
                    cell.newsViewModel = viewModel
                    return cell
                }
                break
            default:
                break
            }
            
            return UICollectionViewCell()
        })
    }
    
    private func configureCollectionViewLayout() {
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
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                    heightDimension: .absolute(370)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                             leading: 16,
                                                             bottom: 16,
                                                             trailing: 16)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
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
    }

    private func configureCollectionView() {
        newsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: newsCollectionLayout)
        
        self.view.addSubview(newsCollectionView)
        newsCollectionView.register(NewsSectionCVCell.self, forCellWithReuseIdentifier: NewsSectionCVCell.cellID)
        newsCollectionView.register(NewsRegularCVCell.self, forCellWithReuseIdentifier: NewsRegularCVCell.cellID)
        newsCollectionView.register(NewsCompactCVCell.self, forCellWithReuseIdentifier: NewsCompactCVCell.cellID)
    }

}

