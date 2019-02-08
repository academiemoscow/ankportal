//
//  UITexInputView.swift
//  ankportal
//
//  Created by Admin on 08/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class UITextInputView: UITextView {

    open var placeholderTextColor: UIColor = UIColor.lightGray
    
    open var placeholder: String = "" {
        didSet {
                if text == "" {
                    self.text = placeholder
                    textColor = placeholderTextColor
                }
        }
    }
    
    open var color: UIColor? {
        didSet {
            if text != placeholder {
                textColor = color
            }
        }
    }
    
    override var text: String! {
        didSet {
            self.delegate?.textViewDidChange!(self)
        }
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        
        self.isEditable = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
