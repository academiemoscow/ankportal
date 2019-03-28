//
//  NewsCollectionViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 22/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
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
        newsNameTextView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
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
        newsTextView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        newsTextView.textAlignment = NSTextAlignment.left
        newsTextView.sizeToFit()
        newsTextView.numberOfLines = 7
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
            NSAttributedString.Key.foregroundColor: UIColor.black,
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
        newsDetailedInfoController.newsName = self.newsName
        firstPageController?.navigationController?.pushViewController(newsDetailedInfoController, animated: true)
    }
    
    @objc func showPhotoGalleryController() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let photoGalleryController = ShowPhotoGalleryCollectionView(collectionViewLayout: layout)
        photoGalleryController.newsId = id
        photoGalleryController.newsName = newsName
        photoGalleryController.newsDate = newsDate
        photoGalleryController.navigationItem.backBarButtonItem?.title = "test"
        firstPageController?.navigationController?.pushViewController(photoGalleryController, animated: true)

    }
    
    let photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.layer.cornerRadius = 10
        photo.isUserInteractionEnabled = true
        return photo
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        backgroundColor = backgroundColor
        setupPhotoImageView()
        
    }
    
    func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(showPhotoGalleryController))
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.addSubview(newsNameView)
        newsNameView.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 4).isActive = true
        newsNameView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        newsNameView.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: -3).isActive = true
        newsNameView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        self.addSubview(newsTextView)
        newsTextView.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 4).isActive = true
        newsTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        newsTextView.topAnchor.constraint(equalTo: newsNameView.bottomAnchor, constant: 0).isActive = true
        newsTextView.heightAnchor.constraint(equalToConstant: 112).isActive = true

        self.addSubview(readFullNewsButton)
        readFullNewsButton.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 4).isActive = true
        readFullNewsButton.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 3).isActive = true
        readFullNewsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        readFullNewsButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
