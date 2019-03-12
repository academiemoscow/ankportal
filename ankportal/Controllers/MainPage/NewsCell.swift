//
//  NewsCell.swift
//  ankportal
//
//  Created by Олег Рачков on 04/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

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
        newsNameTextView.numberOfLines = 4
        newsNameTextView.backgroundColor = UIColor.white
        newsNameTextView.textAlignment = NSTextAlignment.left
        newsNameTextView.sizeToFit()
        newsNameTextView.layer.masksToBounds = true
        newsNameTextView.translatesAutoresizingMaskIntoConstraints = false
        return newsNameTextView
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
        newsImageView.layer.cornerRadius = 10
        newsImageView.layer.masksToBounds = true
        newsImageView.layer.shadowColor = UIColor.black.cgColor
        newsImageView.layer.shadowRadius = 10
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
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraph,
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ]
        let attributedString = NSAttributedString(string: "Фотогалерея", attributes: attributes)
        lookAtGaleryButton.setAttributedTitle(attributedString, for: .normal)
        lookAtGaleryButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        lookAtGaleryButton.titleLabel?.leftAnchor.constraint(equalTo: lookAtGaleryButton.leftAnchor).isActive = true
        lookAtGaleryButton.translatesAutoresizingMaskIntoConstraints = false
        lookAtGaleryButton.addTarget(self, action: #selector(showPhotoGalleryController), for: .touchUpInside)
        return lookAtGaleryButton
    }()
    
    lazy var readFullNewsButton: UIButton = {
        var readFullNewsButton = UIButton()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .right
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraph,
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ]
        let attributedString = NSAttributedString(string: "Подробнее", attributes: attributes)
        readFullNewsButton.setAttributedTitle(attributedString, for: .normal)
        readFullNewsButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        readFullNewsButton.titleLabel?.rightAnchor.constraint(equalTo: readFullNewsButton.rightAnchor).isActive = true
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
        self.mainPageController?.navigationController?.pushViewController(photoGalleryController, animated: true)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(newsImageView)
        newsImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        newsImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        newsImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -25).isActive = true
        newsImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(downConteinerView)
        downConteinerView.leftAnchor.constraint(equalTo: newsImageView.leftAnchor).isActive = true
        downConteinerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        downConteinerView.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor).isActive = true
        downConteinerView.rightAnchor.constraint(equalTo: newsImageView.rightAnchor).isActive = true
        
        self.addSubview(newsNameView)
        newsNameView.leftAnchor.constraint(equalTo: newsImageView.leftAnchor).isActive = true
        newsNameView.widthAnchor.constraint(equalTo: newsImageView.widthAnchor).isActive = true
        newsNameView.bottomAnchor.constraint(equalTo: downConteinerView.topAnchor).isActive = true
        newsNameView.heightAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 0.2).isActive = true
        self.addSubview(newsDateView)
        newsDateView.rightAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: -10).isActive = true
        newsDateView.topAnchor.constraint(equalTo: newsNameView.topAnchor, constant: -18).isActive = true
        newsDateView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        newsDateView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        self.addSubview(newsDateTextView)
        newsDateTextView.rightAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: -10).isActive = true
        newsDateTextView.topAnchor.constraint(equalTo: newsDateView.topAnchor, constant: -4).isActive = true
        newsDateTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        newsDateTextView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        downConteinerView.addSubview(lookAtGaleryImageView)
        lookAtGaleryImageView.leftAnchor.constraint(equalTo: downConteinerView.leftAnchor, constant: 4).isActive = true
        lookAtGaleryImageView.centerYAnchor.constraint(equalTo: downConteinerView.centerYAnchor).isActive = true
        lookAtGaleryImageView.widthAnchor.constraint(equalTo: downConteinerView.widthAnchor, multiplier: 0.05).isActive = true
        lookAtGaleryImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        downConteinerView.addSubview(lookAtGaleryButton)
        lookAtGaleryButton.leftAnchor.constraint(equalTo: lookAtGaleryImageView.rightAnchor, constant: 4).isActive = true
        lookAtGaleryButton.topAnchor.constraint(equalTo: lookAtGaleryImageView.topAnchor).isActive = true
        lookAtGaleryButton.bottomAnchor.constraint(equalTo: lookAtGaleryImageView.bottomAnchor).isActive = true
        lookAtGaleryButton.widthAnchor.constraint(equalTo: downConteinerView.widthAnchor, multiplier: 0.5).isActive = true
      
        downConteinerView.addSubview(readFullNewsImageView)
        readFullNewsImageView.rightAnchor.constraint(equalTo: downConteinerView.rightAnchor, constant: -4).isActive = true
        readFullNewsImageView.centerYAnchor.constraint(equalTo: downConteinerView.centerYAnchor).isActive = true
        readFullNewsImageView.widthAnchor.constraint(equalTo: downConteinerView.widthAnchor, multiplier: 0.05).isActive = true
        readFullNewsImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        downConteinerView.addSubview(readFullNewsButton)
        readFullNewsButton.rightAnchor.constraint(equalTo: readFullNewsImageView.leftAnchor, constant: -4).isActive = true
        readFullNewsButton.topAnchor.constraint(equalTo: readFullNewsImageView.topAnchor).isActive = true
        readFullNewsButton.bottomAnchor.constraint(equalTo: readFullNewsImageView.bottomAnchor).isActive = true
        readFullNewsButton.widthAnchor.constraint(equalTo: downConteinerView.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let newsName = newsName {
            newsNameView.text = newsName
        }
        
        if let newsDate = newsDate {
            newsDateTextView.text = newsDate
        }
        
        if let image = newsImage {
            newsImageView.image = image
        }
        
    }
    
 
    
}


