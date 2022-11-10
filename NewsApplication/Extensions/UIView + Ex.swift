//
//  UIView + Ex.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 10.11.2022.
//

import UIKit

fileprivate var containerView: UIView!

extension UIView {
    
    func showLoadingIndicator() {
        containerView = UIView(frame: self.bounds)
        self.addSubview(containerView)
        
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
        }
    }
    
    func dismissLoadingIndicator() {
        DispatchQueue.main.async {
            containerView?.removeFromSuperview()
            containerView = nil
        }
    }
}
