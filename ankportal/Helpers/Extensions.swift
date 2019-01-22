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
