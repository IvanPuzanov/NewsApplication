//
//  News.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 22.08.2022.
//

import Foundation

struct News: Codable {
    var section: String
    var subsection: String
    var title: String
    var abstract: String
    var url: String
    var updatedDate: String
    var byline: String
    var multimedia: [NewsMedia]?
}

extension News {
    static func placeholderNews() -> News {
        return News(section: .init(), subsection: .init(), title: .init(), abstract: .init(),
                    url: .init(), updatedDate: .init(), byline: .init())
    }
}
