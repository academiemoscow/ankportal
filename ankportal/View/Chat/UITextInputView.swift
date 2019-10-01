//
//  UITexInputView.swift
//  ankportal
//
//  Created by Admin on 08/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class UITextInputView: UITextView {

    open var placeholder: String = "" {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var text: String! {
        didSet {
            updatePlaceholder()
        }
    }
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        label.text = ""
        label.textColor = .gray
        label.numberOfLines = 1
        label.isUserInteractionEnabled = false
        return label
    }()
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        
        self.isEditable = true
        
    }
    
    public func updatePlaceholder() {
        placeholderLabel.text = placeholder
        if let text = text {
            if !text.isEmpty {
                placeholderLabel.text = nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
