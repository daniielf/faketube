//
//  extensions.swift
//  faketube
//
//  Created by Daniel Freitas on 14/09/19.
//  Copyright © 2019 Daniel Freitas. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func useRawValues(red: Int, green: Int, blue: Int, alpha: Int = 1) -> UIColor {
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha))
    }
    
    static var redMain = UIColor.useRawValues(red: 210, green: 30, blue: 30)
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


