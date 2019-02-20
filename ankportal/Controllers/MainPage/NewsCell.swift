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
    var newsImageUrl: String?
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
    
    var newsImageView: UIImageView = {
        var newsImageView = UIImageView()
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.layer.cornerRadius = 10
        newsImageView.layer.masksToBounds = true
        newsImageView.layer.shadowColor = UIColor.black.cgColor
        newsImageView.layer.shadowRadius = 10
        return newsImageView
    }()
    
    func loadImageFromUrl(urlString: String) {
        
        var imageNews: UIImage = UIImage(named: "newslist_placeholder")!
        
        if let imageFromCache = imageNewsPhotoCache.object(forKey: urlString as AnyObject) as? UIImage {
            imageNews = imageFromCache
            newsImageView.image = imageFromCache
            return
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url,completionHandler: {(data, result, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    let imageForCache = UIImage(data: data!)
                    imageNewsPhotoCache.setObject(imageForCache!, forKey: urlString as AnyObject)
                    imageNews = imageForCache!
                    self.newsImageView.image = imageForCache
                
                }
            }).resume()
        }
        newsImageView.image = imageNews
        
    }
    
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
        loadImageFromUrl(urlString: newsImageUrl!)
        
        newsImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        newsImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        newsImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -25).isActive = true
        newsImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        newsTextPlaceholderView.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 2).isActive = true
        newsTextPlaceholderView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        newsTextPlaceholderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        newsTextPlaceholderView.heightAnchor.constraint(equalTo: newsImageView.heightAnchor).isActive = true
        
        self.addSubview(newsNameView)
        newsNameView.centerXAnchor.constraint(equalTo: newsImageView.centerXAnchor).isActive = true
        newsNameView.widthAnchor.constraint(equalTo: newsImageView.widthAnchor).isActive = true
        newsNameView.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 0).isActive = true
        newsNameView.heightAnchor.constraint(equalToConstant: 150).isActive = true
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



extension UIImageView {
    
 
    
}
