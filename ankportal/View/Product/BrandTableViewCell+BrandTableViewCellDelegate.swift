//
//  BrandTableViewCell.swift
//  ankportal
//
//  Created by Admin on 03/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

protocol BrandTableViewCellDelegate: class {
    func didSelect(brand: ANKPortalItemSelectable)
}

class BrandTableViewCell: UITableViewCell {
    
    private var brand: ANKPortalItemSelectable?
    weak var delegate: BrandTableViewCellDelegate?
    
    lazy var nameTextLabel: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .subheadline)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textAlignment = NSTextAlignment.center
        return textView
    }()
    
    lazy var logoImageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.activityIndicator = nil
        imageView.transformImage = { (image) in
            return image.cropping(to: UIImage.ImageRegion.bottomHalf)
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var selectButton: CheckmarkButton = {
        let button = CheckmarkButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.addTarget(self, action: #selector(selectButtonHandler), for: .touchUpInside)
        return button
    }()
    
    lazy var deselectButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("Убрать", for: .normal)
        button.backgroundColor = UIColor.black//ankpurple
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.addTarget(self, action: #selector(selectButtonHandler), for: .touchUpInside)
        return button
    }()
    
    lazy var verticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextLabel, logoImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        return stackView
    }()
    
    lazy var horizontalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [verticalStack, selectButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.center
        return stackView
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.5)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @objc func selectButtonHandler() {
        if let brand = brand {
            delegate?.didSelect(brand: brand)
        }
    }
    
    private func setupView() {
        addSubview(horizontalStack)
        horizontalStack.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
        horizontalStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        horizontalStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        horizontalStack.heightAnchor.constraint(equalTo: heightAnchor, constant: -32).isActive = true
        
        addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor, constant: -16).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func configure(forBrand brand: ANKPortalItemSelectable) {
        self.brand = brand
        nameTextLabel.text = brand.name
        logoImageView.image = nil
        nameTextLabel.isHidden = false
        
        selectButton.isChecked = brand.isSelected
        
        guard let logoURLString = brand.logo else {
            logoImageView.isHidden = true
            return
        }
        
        logoImageView.isHidden = false
        nameTextLabel.isHidden = true
        
//        nameTextLabel.isHidden = true
        
        if let url = URL(string: logoURLString) {
            logoImageView.loadImageWithUrl(url)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
