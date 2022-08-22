//
//  NewsResultViewModel.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import RxSwift

class NewsResultViewModel {
    
    private(set) var newsViewModels: BehaviorSubject<[NewsViewModel]> = .init(value: [])
    
    public func loadData() {
        DispatchQueue.main.async {
            NetworkManager
                .shared
                .fetchData(ofType: NewsResult.self, from: "https://api.nytimes.com/svc/topstories/v2/arts.json?api-key=QauJAWFmlv0WIhtlPKOujZuigpuc2AiK")
                .map { $0.results.map { NewsViewModel(news: $0) }
                }
                .subscribe { newsResult in
                    self.newsViewModels.onNext(newsResult)
                    
                } onError: { error in
                    self.newsViewModels.onError(error)
                }
        }
    }
    
}
