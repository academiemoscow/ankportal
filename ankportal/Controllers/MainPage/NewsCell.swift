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
    
    let cellid = "NewsCell"
    var newslist: [News] = []
    
    var newsIdView: UITextView = {
        var newsIdVTextiew = UITextView()
        newsIdVTextiew.translatesAutoresizingMaskIntoConstraints = false
        return newsIdVTextiew
    }()
    
    var newsNameView: UILabel = {
        var newsNameTextView = UILabel()
        newsNameTextView.translatesAutoresizingMaskIntoConstraints = false
        newsNameTextView.font = UIFont.systemFont(ofSize: 16)
        return newsNameTextView
    }()
    
    var newsDateView: UILabel = {
        var newsDateTextView = UILabel()
        newsDateTextView.translatesAutoresizingMaskIntoConstraints = false
        newsDateTextView.font = UIFont.boldSystemFont(ofSize: 12)
        return newsDateTextView
    }()
    
    var newsPreviewTextView: UILabel = {
        var newsPreviewTextView = UILabel()
        newsPreviewTextView.numberOfLines = 4
        newsPreviewTextView.translatesAutoresizingMaskIntoConstraints = false
        newsPreviewTextView.font = UIFont.systemFont(ofSize: 12)
        return newsPreviewTextView
    }()
    
    var newsImageView: UIImageView = {
        var newsImageView = UIImageView()
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.image = UIImage(named: "newslist_placeholder")
        return newsImageView
    }()
    
    var newsTextPlaceholderView: UIImageView = {
        var newsImageView = UIImageView()
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.image = UIImage(named: "newslist_placeholder2")
        return newsImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       // self.retrieveNewsList()
        
        self.addSubview(newsTextPlaceholderView)
        self.addSubview(newsImageView)
        self.addSubview(newsNameView)
        self.addSubview(newsDateView)
        self.addSubview(newsPreviewTextView)
        
        newsImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        newsImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        newsImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        newsImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        newsImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        newsTextPlaceholderView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 2).isActive = true
        newsTextPlaceholderView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        newsTextPlaceholderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        newsTextPlaceholderView.heightAnchor.constraint(equalTo: newsImageView.heightAnchor).isActive = true
        
        newsNameView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 4).isActive = true
        newsNameView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        newsNameView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        newsNameView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        newsDateView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 4).isActive = true
        newsDateView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        newsDateView.topAnchor.constraint(equalTo: newsNameView.bottomAnchor).isActive = true
        newsDateView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        newsPreviewTextView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 4).isActive = true
        newsPreviewTextView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        newsPreviewTextView.topAnchor.constraint(equalTo: newsDateView.bottomAnchor, constant: 0).isActive = true
        newsPreviewTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
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
        
        if let textPreview = textPreview {
            newsPreviewTextView.text = textPreview
        }
        
        if let image = newsImage {
            newsImageView.image = image
        }
        
    }
    
 
    
}
