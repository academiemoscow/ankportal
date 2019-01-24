//
//  Extensions.swift
//  ankportal
//
//  Created by Admin on 22/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func displayError(withTitle title: String, withErrorText error: String, presentIn view: UIViewController) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIColor {
    
    static let ballonBlue: UIColor = UIColor(r: 0, g: 134, b: 181)
    static let ballonGrey: UIColor = UIColor(r: 245, g: 245, b: 245)
    static let emeraldGreen: UIColor = UIColor(r: 80, g: 200, b: 120)
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
