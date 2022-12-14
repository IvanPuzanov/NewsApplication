//
//  String + Ex.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 21.08.2022.
//

import Foundation

extension String {
    
    /// Format Date
    /// - Returns: Formatted date
    func convertToDate() -> Date? {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone      = .current
        
        return dateFormatter.date(from: self)
    }
    
    /// Convert Date to readable String
    /// - Returns: Converted date
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
    
}
