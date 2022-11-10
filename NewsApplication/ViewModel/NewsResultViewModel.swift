//
//  NewsResultViewModel.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import RxSwift
import Network

final class NewsResultViewModel {
    
    // MARK: - Parameters
    private let disposeBag = DisposeBag()
    
    private(set) var newsViewModels: BehaviorSubject<[NewsViewModel]> = .init(value: [.placeholderViewModel(), .placeholderViewModel()])
    public var newsSections: [String] {
        return filterBySections()
    }
    
    // MARK: - Initialization
    init() { }
    
    // MARK: -
    /// Fetching news data from network
    @objc
    public func loadData() {
        DispatchQueue.global().async {
            NetworkManager
                .shared
                .fetchData(ofType: NewsResult.self, from: Project.Network.Link.baseURL)
                .map { $0.results.map { NewsViewModel(news: $0) }
                }
                .subscribe { newsResult in
                    self.newsViewModels.onNext(newsResult)
                } onError: { error in
                    self.newsViewModels.onError(error)
                }.disposed(by: self.disposeBag)
        }
    }
    
    /// Filtering news by sections
    /// - Returns: Array of sections
    private func filterBySections() -> [String] {
        var sections = [String]()
        do {
            let viewModels = try newsViewModels.value()

            var newsSections: [String] = ["All"]
            viewModels.forEach {
                guard !newsSections.contains($0.section) else { return }
                newsSections.append($0.section)
            }

            sections = newsSections
            return sections
        } catch {
            return []
        }
    }
    
    public func didSelectSection(in collectionView: UICollectionView, at indexPath: IndexPath) -> [NewsViewModel]? {
        collectionView.indexPathsForSelectedItems?.forEach { index in
            guard indexPath != index else { return }
            collectionView.deselectItem(at: index, animated: true)
        }
        
        var viewModels = [NewsViewModel]()
        do {
            viewModels = try newsViewModels.value()
        } catch { return nil }
        
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                return viewModels
            default:
                let filtered = viewModels.filter { $0.section.lowercased() == newsSections[indexPath.row].lowercased() }
                return filtered
            }
        default:
            break
        }
        
        return nil
    }
    
    /// Fetch news view model for selection
    /// - Parameters:
    ///   - collectionView:
    ///   - indexPath: Selection index
    /// - Returns: NewsViewModel on selection
    public func didSelectNews(in collectionView: UICollectionView, at indexPath: IndexPath) -> NewsViewModel? {
        guard indexPath.section != 0 else { return nil }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? NewsViewModelProtocol {
            collectionView.deselectItem(at: indexPath, animated: true)
            let viewModel = cell.newsViewModel
            return viewModel
        }
        
        return nil
    }
    
    /// Prepare news for sections
    /// - Parameter news: Array of news for preparing
    /// - Returns: Prepared news tuple
    public func prepareNews(news: [NewsViewModel]) -> (regular: [NewsViewModel], compact: [NewsViewModel]) {
        var regularNews = [NewsViewModel]()
        var compactNews = [NewsViewModel]()
        
        news.forEach { viewModel in
            if regularNews.count < 3 {
                regularNews.append(viewModel)
            } else {
                compactNews.append(viewModel)
            }
        }
        
        return (regular: regularNews, compact: compactNews)
    }
}
