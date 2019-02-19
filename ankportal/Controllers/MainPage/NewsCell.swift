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
        newsNameTextView.font = UIFont.systemFont(ofSize: 20)
        newsNameTextView.numberOfLines = 5
        newsNameTextView.backgroundColor = UIColor(white: 1, alpha: 0.75)
        newsNameTextView.textAlignment = NSTextAlignment.center
        newsNameTextView.sizeToFit()
        newsNameTextView.layer.masksToBounds = true
        newsNameTextView.translatesAutoresizingMaskIntoConstraints = false
        return newsNameTextView
    }()
    
    var newsDateView: UILabel = {
        var newsDateTextView = UILabel()
        newsDateTextView.translatesAutoresizingMaskIntoConstraints = false
        newsDateTextView.font = UIFont.boldSystemFont(ofSize: 14)
        newsDateTextView.textAlignment = NSTextAlignment.center
        newsDateTextView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        newsDateTextView.layer.masksToBounds = true
        return newsDateTextView
    }()
//
//    var newsPreviewTextView: UILabel = {
//        var newsPreviewTextView = UILabel()
//        newsPreviewTextView.numberOfLines = 4
//        newsPreviewTextView.translatesAutoresizingMaskIntoConstraints = false
//        newsPreviewTextView.font = UIFont.systemFont(ofSize: 12)
//        return newsPreviewTextView
//    }()
//
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
    
    var newsTextPlaceholderView: UIImageView = {
        var newsImageView = UIImageView()
//        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.image = UIImage(named: "newslist_placeholder2")
        return newsImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.addSubview(newsTextPlaceholderView)
        self.addSubview(newsImageView)
        
        
        newsImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        newsImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        newsImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -25).isActive = true
        newsImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        
        
        newsTextPlaceholderView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 2).isActive = true
        newsTextPlaceholderView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        newsTextPlaceholderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        newsTextPlaceholderView.heightAnchor.constraint(equalTo: newsImageView.heightAnchor).isActive = true
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
//
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = newsNameView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.alpha = 0.8
//        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(blurEffectView)
//        blurEffectView.centerXAnchor.constraint(equalTo: newsImageView.centerXAnchor).isActive = true
//        blurEffectView.widthAnchor.constraint(equalTo: newsImageView.widthAnchor).isActive = true
//        blurEffectView.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 0).isActive = true
//        blurEffectView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.addSubview(newsNameView)
        newsNameView.centerXAnchor.constraint(equalTo: newsImageView.centerXAnchor).isActive = true
        newsNameView.widthAnchor.constraint(equalTo: newsImageView.widthAnchor).isActive = true
        newsNameView.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 0).isActive = true
        newsNameView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        newsDateView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        newsDateView.widthAnchor.constraint(equalTo: newsImageView.widthAnchor).isActive = true
//        newsDateView.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 0).isActive = true
//        newsDateView.heightAnchor.constraint(equalToConstant: 20    ).isActive = true

//        newsPreviewTextView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 4).isActive = true
//        newsPreviewTextView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        newsPreviewTextView.topAnchor.constraint(equalTo: newsDateView.bottomAnchor, constant: 0).isActive = true
//        newsPreviewTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
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
            newsDateView.text = newsDate
        }
        
        if let image = newsImage {
            newsImageView.image = image
        }
        
    }
    
 
    
}


