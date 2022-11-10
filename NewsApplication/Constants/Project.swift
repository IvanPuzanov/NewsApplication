//
//  Project.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 10.11.2022.
//

import UIKit

enum Project {
    enum Strings {
        static let newsTitle    = "News"
        static let profileTitle = "Profile"
    }
    
    enum Image {
        static let placeholderImage = UIImage(systemName: "photo.fill")
        static let newspaperImage   = UIImage(systemName: "newspaper.fill")
        static let personImage      = UIImage(systemName: "person.circle.fill")
        static let myMemoji         = UIImage(named: "myMemoji")
    }
    
    enum Color {
        static let cellBackground   = UIColor(named: "cellBackground")
        static let tabBarSelected   = UIColor(named: "tabBarSelected")
    }
    
    enum Network {
        enum Link {
            static let baseURL = "https://api.nytimes.com/svc/topstories/v2/arts.json?api-key=QauJAWFmlv0WIhtlPKOujZuigpuc2AiK"
        }
        
        enum Error {
            static let failedURL = "Fail URL"
        }
    }
}
