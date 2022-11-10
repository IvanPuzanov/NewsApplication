//
//  Project.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 10.11.2022.
//

import UIKit

enum Project {
    enum Strings {
        
    }
    
    enum Image {
        static let placeholderImage = UIImage(systemName: "photo.fill")
    }
    
    enum Color {
        static let cellBackground = UIColor(named: "cellBackground")
    }
    
    enum Network {
        enum Link {
            static let baseURL = "https://api.nytimes.com/svc/topstories/v2/arts.json?api-key=QauJAWFmlv0WIhtlPKOujZuigpuc2AiK"
        }
        
        enum Error {
            
        }
    }
}
