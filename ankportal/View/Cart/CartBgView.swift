//
//  CartBgView.swift
//  ankportal
//
//  Created by Admin on 27/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class CartBgView: UIView {
    
    lazy var smileView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sad_smile"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Здесь пусто :("
        label.textColor = .gray
        label.font = UIFont.defaultFontBold(forTextStyle: .footnote)
        label.textAlignment = .center
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [smileView, label])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.transform = CGAffineTransform(scaleX: 0, y: 0)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        addSubview(stack)
        
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalToConstant: 100).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            usingSpringWithDamping: 0.49,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut],
            animations: {
                self.stack.transform = CGAffineTransform.identity
        }
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
