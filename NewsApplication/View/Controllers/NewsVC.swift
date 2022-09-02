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
    
    private var newsCollectionView: NewsCollectionView!
    private var newsCollectionDataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootView()
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

        snapshot.appendItems(viewModel.newsSections, toSection: .section)
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

    private func configureCollectionView() {
        newsCollectionView = NewsCollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewLayout())        
        self.view.addSubview(newsCollectionView)
        
        NSLayoutConstraint.activate([
            newsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            newsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

