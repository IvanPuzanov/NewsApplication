//
//  Date + Ex.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 21.08.2022.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFromatter = DateFormatter()
        dateFromatter.dateFormat = "MMMM d, yyyy"
        
        return dateFromatter.string(from: self)
    }
    
}
