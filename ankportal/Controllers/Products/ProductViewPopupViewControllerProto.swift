//
//  ProductViewPopupViewController.swift
//  ankportal
//
//  Created by Admin on 29/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

struct ProductProto {
    var name: String
    var imagePath: String
    var lotn: String?
    var expirationDate: String?
}

class ProductViewPopupViewControllerProto: UIViewController {
    
    var product: ProductProto?
    
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
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var lotnTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = UIFont.preferredFont(forTextStyle: .subheadline)
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor.gray
        view.isScrollEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var expDateTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = UIFont.preferredFont(forTextStyle: .subheadline)
        view.textColor = UIColor.gray
        view.isScrollEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var verticalStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextView, lotnTextView, expDateTextView, previewImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
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
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.addSubview(containerView)
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        containerView.addSubview(verticalStack)
        verticalStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        verticalStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        verticalStack.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -padding * 2).isActive = true
        verticalStack.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -padding * 2).isActive = true
        
        lotnTextView.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: -10).isActive = true
        expDateTextView.topAnchor.constraint(equalTo: lotnTextView.bottomAnchor, constant: -10).isActive = true
    }
    
    func configure(forModel model: ProductProto) {
        nameTextView.text = model.name
        if let url = URL(string: model.imagePath.encodeURL) {
            previewImageView.loadImageWithUrl(url)
        }
        if let lotnText = model.lotn {
            lotnTextView.text = lotnText
        }
        if let expDateText = model.expirationDate {
            expDateTextView.text = "годен до \(expDateText)"
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
