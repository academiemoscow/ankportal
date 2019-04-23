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

extension NSNumber {
    
    static func intervalSince1970() -> NSNumber {
        return NSNumber(value: Date().timeIntervalSince1970)
    }
    
}

extension UIImage {
    
    public func portraitOriented() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let portraitOrientedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return portraitOrientedImage
        }
        return self
    }
}

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}

extension UIView {
    
    func makeShadow(color: UIColor = UIColor.black, opacity: Float = 0.5, offset: CGSize = CGSize(width: -1, height: 1), radius: CGFloat = 5) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shouldRasterize = true
        
    }
    
}
