//
//  CALayer + Ex.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 10.11.2022.
//

import UIKit

extension CALayer {
    
    func configure(cornerRadius: CGFloat, setShadow: Bool = false) {
        self.cornerRadius = cornerRadius
        self.cornerCurve  = .continuous
    
        guard setShadow else { return }
        self.shadowColor   = UIColor.black.cgColor
        self.shadowOffset  = CGSize(width: 0, height: 0)
        self.shadowRadius  = 10
        self.shadowOpacity = 0.1
    }
    
}
