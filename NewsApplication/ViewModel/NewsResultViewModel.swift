//
//  NewsResultViewModel.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import RxSwift
import Network

class NewsResultViewModel {
    
    // MARK: -
    private let disposeBag = DisposeBag()
    
    private(set) var newsViewModels: BehaviorSubject<[NewsViewModel]> = .init(value: [.defaultViewModel(), .defaultViewModel(), .defaultViewModel(), .defaultViewModel()])
    public var newsSections: [String] {
        get { return filterBySections() }
    }
    
    private(set) var selectedSection: IndexPath = IndexPath(row: 0, section: 0)
    
    // MARK: -
    init() { }
    
    // MARK: -
    /// Загрузка новостных данных из сети
    @objc
    public func loadData() {
        DispatchQueue.global().async {
            NetworkManager
                .shared
                .fetchData(ofType: NewsResult.self, from: "https://api.nytimes.com/svc/topstories/v2/arts.json?api-key=QauJAWFmlv0WIhtlPKOujZuigpuc2AiK")
                .map { $0.results.map { NewsViewModel(news: $0) }
                }
                .subscribe { newsResult in
                    self.newsViewModels.onNext(newsResult)
                } onError: { error in
                    self.newsViewModels.onError(error)
                }.disposed(by: self.disposeBag)
        }
    }
    
    /// Фильтр новостей по секциям
    /// - Returns: Массив строк секций
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
    
    public func didSelectSection(at indexPath: IndexPath) -> [NewsViewModel]? {
        self.selectedSection = indexPath
        
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
    
    public func didSelectNews(in collectionView: UICollectionView, at indexPath: IndexPath) -> NewsViewModel? {
        guard indexPath.section != 0 else { return nil }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? NewsViewModelProtocol {
            return cell.newsViewModel
        }
        
        return nil
    }
    
    
    public func prepareNews(news: [NewsViewModel]) -> (regular: [NewsViewModel], compact: [NewsViewModel]) {
        var regularNews = [NewsViewModel]()
        var compactNews = [NewsViewModel]()
        
        news.enumerated().forEach { index, viewModel in
            if regularNews.count < 3 {
                regularNews.append(viewModel)
            } else {
                compactNews.append(viewModel)
            }
        }
        
        return (regular: regularNews, compact: compactNews)
    }
}
