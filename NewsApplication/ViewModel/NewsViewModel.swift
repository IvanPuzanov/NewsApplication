//
//  NewsViewModel.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 22.08.2022.
//

import UIKit
import RxSwift
import RxRelay

final class NewsViewModel {
   
    // MARK: - Parameters
    let id = UUID().uuidString
    
    var section: String
    var subsection: String
    var title: String
    var date: String
    var url: URL?
    var author: String
    var image: BehaviorRelay<UIImage> = .init(value: Project.Image.placeholderImage!)
    
    var isPlaceholder: Bool = false
    
    // MARK: - Initializatoin
    init(news: News) {
        self.section    = news.section
        self.subsection = news.subsection
        self.title      = news.title
        self.date       = news.updatedDate.convertToDisplayFormat()
        self.url        = URL(string: news.url)
        self.author     = news.byline
        
        guard let url = news.multimedia?.first(where: { $0.format == "threeByTwoSmallAt2X" })?.url else { return }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            NetworkManager.shared.fetchImage(from: url).subscribe { image in
                self.image.accept(image)
            } onError: { _ in }.disposed(by: DisposeBag())
        }
    }
    
}

extension NewsViewModel: Hashable {
    static func == (lhs: NewsViewModel, rhs: NewsViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {}
    
    static func placeholderViewModel() -> NewsViewModel {
        let viewModel = NewsViewModel(news: .placeholderNews())
        viewModel.isPlaceholder = true
        return viewModel
    }
}
