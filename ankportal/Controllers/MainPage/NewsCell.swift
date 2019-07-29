//
//  NewsCell.swift
//  ankportal
//
//  Created by Олег Рачков on 04/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit
struct News {
    let id: String
    let name: String
    let date: String
    let imageURL: String?
    let textPreview: String
    
    
    init(json: [String: Any]) {
        id = json["ID"] as? String ?? ""
        name = json["NAME"] as? String ?? ""
        date = json["DISPLAY_ACTIVE_FROM"] as? String ?? ""
        imageURL = json["PREVIEW_PICTURE"] as? String ?? ""
        textPreview = json["PREVIEW_TEXT"] as? String ?? ""
    }
}

class NewsCell: UITableViewCell {
    var id: String?
    var newsName: String?
    var newsDate: String?
    var newsImage: UIImage?
    var textPreview: String?
    
    var mainPageController: UIViewController?
    
    let cellid = "NewsCell"
    var newslist: [News] = []
    
    var newsIdView: UITextView = {
        var newsIdVTextiew = UITextView()
        newsIdVTextiew.translatesAutoresizingMaskIntoConstraints = false
        return newsIdVTextiew
    }()
    
    var newsNameView: UILabel = {
        var newsNameTextView = UILabel()
        newsNameTextView.font = UIFont.boldSystemFont(ofSize: 14)
        newsNameTextView.backgroundColor = UIColor.white
        newsNameTextView.textAlignment = NSTextAlignment.left
        newsNameTextView.sizeToFit()
        newsNameTextView.numberOfLines = 2
        newsNameTextView.layer.masksToBounds = true
        newsNameTextView.translatesAutoresizingMaskIntoConstraints = false
        return newsNameTextView
    }()
    
    var newsTextView: UILabel = {
        var newsTextView = UILabel()
        newsTextView.font = UIFont.systemFont(ofSize: 12)
        newsTextView.backgroundColor = UIColor.white
        newsTextView.textAlignment = NSTextAlignment.left
        newsTextView.sizeToFit()
        newsTextView.numberOfLines = 5
        newsTextView.layer.masksToBounds = true
        newsTextView.translatesAutoresizingMaskIntoConstraints = false
        return newsTextView
    }()
    
    var newsDateView: UILabel = {
        var newsDateTextView = UILabel()
        newsDateTextView.translatesAutoresizingMaskIntoConstraints = false
        newsDateTextView.font = UIFont.boldSystemFont(ofSize: 14)
        newsDateTextView.textColor = UIColor.gray
        newsDateTextView.textAlignment = NSTextAlignment.center
        newsDateTextView.layer.cornerRadius = 25
        newsDateTextView.backgroundColor = UIColor.white
        newsDateTextView.layer.masksToBounds = true
        return newsDateTextView
    }()
    
    
    
    var newsDateTextView: UILabel = {
        var newsDateTextView = UILabel()
        newsDateTextView.translatesAutoresizingMaskIntoConstraints = false
        newsDateTextView.font = UIFont.boldSystemFont(ofSize: 14)
        newsDateTextView.textColor = UIColor.gray
        newsDateTextView.textAlignment = NSTextAlignment.center
        newsDateTextView.backgroundColor = UIColor(white: 1, alpha: 0)
        newsDateTextView.layer.masksToBounds = true
        return newsDateTextView
    }()
    
    var newsImageView: UIImageView = {
        var newsImageView = UIImageView()
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.image = UIImage(named: "newslist_placeholder")
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.layer.cornerRadius = 5
        newsImageView.layer.masksToBounds = true
        return newsImageView
    }()
    
    var newsNamePlaceholder: UIImageView = {
        var newsNamePlaceholder = UIImageView()
        newsNamePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        newsNamePlaceholder.image = UIImage(named: "newslist_placeholder2")
        return newsNamePlaceholder
    }()
    
    var downConteinerView: UIView = {
        var containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    var lookAtGaleryImageView: UIImageView = {
        var lookAtGaleryImageView = UIImageView()
        lookAtGaleryImageView.image = UIImage(named: "lookAtGaleryIcon")
        lookAtGaleryImageView.translatesAutoresizingMaskIntoConstraints = false
        lookAtGaleryImageView.contentMode = .scaleAspectFit
        return lookAtGaleryImageView
    }()
    
    lazy var lookAtGaleryButton: UIButton = {
        var lookAtGaleryButton = UIButton()
        lookAtGaleryButton.setImage(UIImage(named: "lookAtGaleryIcon"), for: .normal)
        lookAtGaleryButton.translatesAutoresizingMaskIntoConstraints = false
        lookAtGaleryButton.addTarget(self, action: #selector(showPhotoGalleryController), for: .touchUpInside)
        
        return lookAtGaleryButton
    }()
    
    lazy var readFullNewsButton: UIButton = {
        var readFullNewsButton = UIButton()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraph,
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
        ]
        let attributedString = NSAttributedString(string: "Читать далее >", attributes: attributes)
        readFullNewsButton.setAttributedTitle(attributedString, for: .normal)
        readFullNewsButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        readFullNewsButton.titleLabel?.leftAnchor.constraint(equalTo: readFullNewsButton.leftAnchor).isActive = true
        readFullNewsButton.translatesAutoresizingMaskIntoConstraints = false
        readFullNewsButton.addTarget(self, action: #selector(showNewsDetailedInfoController), for: .touchUpInside)
        return readFullNewsButton
    }()
    
    lazy var readFullNewsImageView: UIImageView = {
        var readFullNewsImageView = UIImageView()
        readFullNewsImageView.image = UIImage(named: "readFullNewsIcon")
        readFullNewsImageView.translatesAutoresizingMaskIntoConstraints = false
        readFullNewsImageView.contentMode = .scaleAspectFit
        return readFullNewsImageView
    }()
    
    @objc func showNewsDetailedInfoController() {
        let newsDetailedInfoController = NewsDetailedInfoController()
        newsDetailedInfoController.newsId = id
    
        self.mainPageController?.navigationController?.pushViewController(newsDetailedInfoController, animated: true)
    }
    
    @objc func showPhotoGalleryController() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let photoGalleryController = ShowPhotoGalleryCollectionView(collectionViewLayout: layout)
        photoGalleryController.newsId = id
        photoGalleryController.newsName = newsName
        photoGalleryController.newsDate = newsDate
        self.mainPageController?.navigationController?.pushViewController(photoGalleryController, animated: true)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(newsImageView)
        newsImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        newsImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        newsImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85).isActive = true
        newsImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85).isActive = true
        newsImageView.backgroundColor = UIColor.gray
        self.addSubview(newsNameView)
        newsNameView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 4).isActive = true
        newsNameView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        newsNameView.topAnchor.constraint(equalTo: newsImageView.topAnchor, constant: -3).isActive = true
        newsNameView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        self.addSubview(newsTextView)
        newsTextView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 4).isActive = true
        newsTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        newsTextView.topAnchor.constraint(equalTo: newsNameView.bottomAnchor, constant: 4).isActive = true
        newsTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        self.addSubview(newsDateView)
        newsDateView.centerXAnchor.constraint(equalTo: newsImageView.centerXAnchor, constant: 0).isActive = true
        newsDateView.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 18).isActive = true
        newsDateView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        newsDateView.widthAnchor.constraint(equalTo: newsImageView.widthAnchor, multiplier: 0.9).isActive = true
        
        newsDateView.addSubview(newsDateTextView)
        newsDateTextView.leftAnchor.constraint(equalTo: newsDateView.leftAnchor).isActive = true
        newsDateTextView.bottomAnchor.constraint(equalTo: newsDateView.centerYAnchor).isActive = true
        newsDateTextView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        newsDateTextView.widthAnchor.constraint(equalTo: newsDateView.widthAnchor, multiplier: 0.75).isActive = true
        
        self.addSubview(lookAtGaleryButton)
        lookAtGaleryButton.rightAnchor.constraint(equalTo: newsDateView.rightAnchor, constant: -12).isActive = true
        lookAtGaleryButton.topAnchor.constraint(equalTo: newsDateView.topAnchor).isActive = true
        lookAtGaleryButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lookAtGaleryButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(readFullNewsButton)
        readFullNewsButton.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 4).isActive = true
        readFullNewsButton.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 3).isActive = true
        readFullNewsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        readFullNewsButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        newsImageView.layer.shadowColor = UIColor.gray.cgColor
        newsImageView.layer.shadowOpacity = 0.5
        newsImageView.layer.shadowOffset = CGSize(width: 10, height: 10)
        newsImageView.layer.shadowRadius = 5
        newsImageView.layer.shadowPath = UIBezierPath(rect: newsImageView.bounds).cgPath
        newsImageView.layer.shouldRasterize = true
        newsImageView.layer.rasterizationScale = 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let newsName = newsName {
            newsNameView.text = newsName
        }
        
        if let textPreview = textPreview {
            newsTextView.text = textPreview
        }
        
        if let newsDate = newsDate {
            newsDateTextView.text = newsDate
        }
        
        if let image = newsImage {
            newsImageView.image = image
        }
        
    }
    
    
    
}


