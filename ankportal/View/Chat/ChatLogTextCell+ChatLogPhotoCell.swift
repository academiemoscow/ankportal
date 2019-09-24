//
//  ChatLogChatBallonCellCollectionViewCell.swift
//  ankportal
//
//  Created by Admin on 22/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit
import Firebase

class ChatMessageCell: UICollectionViewCell {
    
    let padding: CGFloat = 8
    
    var textLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isScrollEnabled = false
        label.textAlignment = .left
        return label
    }()
    
    lazy var bgView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor.black
        bv.layer.cornerRadius = 16
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    lazy var viewWidthAnchor: NSLayoutConstraint = {
        let constraint = bgView.widthAnchor.constraint(equalToConstant: 190)
        constraint.isActive = true
        return constraint
    }()
    
    lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.gray
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tapView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var imageView: UIImageView?
    
    func attachImage(image: UIImage) {
        imageView = UIImageView()
        imageView?.layer.cornerRadius = bgView.layer.cornerRadius
        imageView?.backgroundColor = UIColor.black
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
        imageView!.image = image
        addSubview(imageView!)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.widthAnchor.constraint(equalTo: bgView.widthAnchor, constant: 0).isActive = true
        imageView?.heightAnchor.constraint(equalTo: bgView.heightAnchor, constant: 0).isActive = true
        imageView?.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        imageView?.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        bgView.backgroundColor = UIColor.clear
        bringSubviewToFront(timestampLabel)
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    func startAnimating() {
        bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    private func layoutViews() {
        addSubview(bgView)
        bgView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
        bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bgView.addSubview(textLabel)
        textLabel.heightAnchor.constraint(equalTo: bgView.heightAnchor, constant: -5).isActive = true
        textLabel.widthAnchor.constraint(equalTo: bgView.widthAnchor, constant: -16).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        
        bgView.addSubview(tapView)
        tapView.topAnchor.constraint(equalTo: bgView.topAnchor).isActive = true
        tapView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
        tapView.leftAnchor.constraint(equalTo: bgView.leftAnchor).isActive = true
        tapView.rightAnchor.constraint(equalTo: bgView.rightAnchor).isActive = true
        
        addSubview(timestampLabel)
        timestampLabel.topAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 2).isActive = true
        timestampLabel.rightAnchor.constraint(equalTo: bgView.rightAnchor).isActive = true
        
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        self.imageView?.removeFromSuperview()
        self.imageView = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OutgoingMessageCell: ChatMessageCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        bgView.backgroundColor = UIColor.black
        bgView.rightAnchor
            .constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -padding).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bgView.backgroundColor = UIColor.black
    }
}

class IncomingMessageCell: ChatMessageCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        bgView.backgroundColor = UIColor.ballonGrey
        bgView.leftAnchor
            .constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: padding).isActive = true
        
        textLabel.textColor = UIColor.black
        timestampLabel.textColor = UIColor.gray
//        timestampLabel.constraints.removeAll()
//        timestampLabel.topAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 2).isActive = true
//        timestampLabel.rightAnchor.constraint(equalTo: bgView.rightAnchor).isActive = true
//        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bgView.backgroundColor = UIColor.ballonGrey
    }
}

