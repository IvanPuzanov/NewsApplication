//
//  NewsResultViewModel.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import RxSwift

class NewsResultViewModel {
    
    // MARK: -
    private let disposeBag = DisposeBag()
    private(set) var newsViewModels: BehaviorSubject<[NewsViewModel]> = .init(value: [])
    public var newsSections: [String] {
        get {
            return filterBySections()
        }
    }
    
    // MARK: -
    /// Загрузка новостных данных из сети
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
        
        newsViewModels.subscribe { viewModels in
            var newsSections: [String] = ["All"]
            viewModels.forEach {
                guard !newsSections.contains($0.section) else { return }
                newsSections.append($0.section)
            }
            sections = newsSections
        } onError: { _ in }.disposed(by: disposeBag)
        
        return sections
    }
    
    public func didSelectItem(at: IndexPath) -> [NewsViewModel] {
        
    }
}
