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
    
    var chatController: ChatLogController?
    
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
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
        imageView!.image = image
        addSubview(imageView!)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.widthAnchor.constraint(equalTo: bgView.widthAnchor, constant: 0).isActive = true
        imageView?.heightAnchor.constraint(equalTo: bgView.heightAnchor, constant: 0).isActive = true
        imageView?.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        imageView?.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        
        imageView?.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(zoomImage))
        imageView?.addGestureRecognizer(tapGestureRecognizer)
        bringSubviewToFront(timestampLabel)
    }
    
    var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.isScrollEnabled = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.layer.borderWidth = 2
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(animatingZoomOut))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        return scrollView
    }()
        
    var photoImageView: UIImageView = {
        var photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = UIColor.backgroundColor
        photoImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(animatingZoomOut))
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
        return photoImageView
    }()
    
    let zoomImageView: UIImageView = {
        let zoomImageView = UIImageView()
        zoomImageView.contentMode = .scaleToFill
        zoomImageView.clipsToBounds = true
        zoomImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(animatingZoomOut))
        zoomImageView.addGestureRecognizer(tapGestureRecognizer)
        return zoomImageView
    }()
    
    @objc func zoomImage() {
        chatController?.view.addSubview(scrollView)
        scrollView.addSubview(photoImageView)
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
        photoImageView.image = imageView?.image
        animatingZoomIn()
    }

    let screenSize = UIScreen.main.bounds

    func animatingZoomIn() {
        UIView.animate(withDuration: 0, animations: { () -> Void in
            self.scrollView.frame = CGRect(x: (self.chatController?.view.frame.minX)!, y: (self.chatController?.view.frame.minY)!, width: self.screenSize.width*0.75, height: self.screenSize.height*0.75)
        })
    }

    @objc func animatingZoomOut() {
        print("!!!!!!!!!!")
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.zoomImageView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        })

    }
    
    let activityIndicator: UIActivityIndicatorView = {
        var indicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .large)
        } else {
            indicator = UIActivityIndicatorView(style: .gray)
        }
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


