//
//  ProductViewPopupViewController.swift
//  ankportal
//
//  Created by Admin on 29/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class ProductViewPopupViewController: UIViewController {
    
    var product: ProductPreview?
    
    var padding: CGFloat {
        get {
            return 24
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 50
        return view
    }()
    
    lazy var previewImageView: ImageLoader = {
        let view = ImageLoader()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = UIFont.defaultFont(forTextStyle: .title3)?.withSize(16)
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    lazy var verticalStack: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [nameTextView, previewImageView])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.spacing = 20
//        return stackView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        if let product = product {
            configure(forModel: product)
        }
    }
    
    private func setupViews() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(containerView)
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
//        containerView.addSubview(nameTextView)
//        nameTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding / 2).isActive = true
//        nameTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: padding).isActive = true
//        nameTextView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -padding * 2).isActive = true
//        nameTextView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -padding * 2).isActive = true
        
        containerView.addSubview(previewImageView)
        previewImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding / 2).isActive = true
        previewImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        previewImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.35).isActive = true
        previewImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding*2).isActive = true
        previewImageView.layer.borderWidth = 2
        previewImageView.layer.borderColor = UIColor.red.cgColor
    }
    
    func configure(forModel model: ProductPreview) {
        nameTextView.text = model.name
        if let url = URL(string: model.previewPicture.encodeURL) {
            previewImageView.loadImageWithUrl(url)
        }
    }
    
    @objc private func handleTap() {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
