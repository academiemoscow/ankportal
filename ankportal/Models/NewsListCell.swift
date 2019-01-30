//
//  NewsListCell.swift
//  ankportal
//
//  Created by Олег Рачков on 30/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import  UIKit

class NewsListCell: UITableViewCell {
    var id: String?
    var newsName: String?
    var newsDate: String?
    var newsImage: UIImage?
    var textPreview: String?
    
    
    var newsIdView: UITextView = {
        var newsIdVTextiew = UITextView()
        newsIdVTextiew.translatesAutoresizingMaskIntoConstraints = false
        
        return newsIdVTextiew
    }()
    
    var newsNameView: UITextView = {
        var newsNameTextView = UITextView()
        newsNameTextView.translatesAutoresizingMaskIntoConstraints = false
        newsNameTextView.isScrollEnabled = false
        newsNameTextView.isEditable = false
        newsNameTextView.font = UIFont.systemFont(ofSize: 18)
//        newsNameTextView.Un
        return newsNameTextView
    }()
    
    var newsDateView: UITextView = {
        var newsDateTextView = UITextView()
        newsDateTextView.translatesAutoresizingMaskIntoConstraints = false
        newsDateTextView.isEditable = false
        newsDateTextView.isScrollEnabled = false
        newsDateTextView.font = UIFont.boldSystemFont(ofSize: 12)
        return newsDateTextView
    }()
    
    var newsPreviewTextView: UITextView = {
        var newsPreviewTextView = UITextView()
        newsPreviewTextView.translatesAutoresizingMaskIntoConstraints = false
        newsPreviewTextView.isScrollEnabled = false
        newsPreviewTextView.isEditable = false
        return newsPreviewTextView
    }()
    
    var newsImageView: UIImageView = {
        var newsImageView = UIImageView()
        newsImageView.image = UIImage(named: "find_icon")
        return newsImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       // self.addSubview(newsIdView)
        self.addSubview(newsNameView)
        self.addSubview(newsDateView)
        self.addSubview(newsPreviewTextView)
        self.addSubview(newsImageView)
        
        newsImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        newsImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        newsImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        newsImageView.widthAnchor.constraint(equalToConstant: 100)
        newsImageView.heightAnchor.constraint(equalToConstant: 100)
        newsImageView.image = UIImage(named: "find_icon")
        
        newsNameView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 4).isActive = true
        newsNameView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        newsNameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        newsNameView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        newsDateView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 4).isActive = true
        newsDateView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        newsDateView.topAnchor.constraint(equalTo: newsNameView.bottomAnchor).isActive = true
        newsDateView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        newsPreviewTextView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 4).isActive = true
        newsPreviewTextView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        newsPreviewTextView.topAnchor.constraint(equalTo: newsDateView.bottomAnchor).isActive = true
        newsPreviewTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
