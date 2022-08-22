//
//  NewsViewModel.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 22.08.2022.
//

import UIKit
import RxSwift

class NewsViewModel {
   
    let id = UUID().uuidString
    
    var section: String
    var title: String
    var date: String
    var url: String
    var image: BehaviorSubject<UIImage> = .init(value: UIImage(systemName: "photo.fill")!)
    
    // MARK: -
    init(news: News) {
        self.section    = news.section
        self.title      = news.title
        self.date       = news.updated_date.convertToDisplayFormat()
        self.url        = news.url
        
        DispatchQueue.global().async {
            guard let url = news.multimedia?.first(where: { $0.format == "threeByTwoSmallAt2X" })?.url else { return }
            
            NetworkManager.shared.fetchImage(from: url).subscribe { image in
                self.image.onNext(image)
            } onError: { error in
                print(error)
            }.disposed(by: DisposeBag())
        }

    }
    
}

extension NewsViewModel: Hashable {
    static func == (lhs: NewsViewModel, rhs: NewsViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {}
}
