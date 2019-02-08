//
//  NewsDetailedInfoController.swift
//  ankportal
//
//  Created by Олег Рачков on 30/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import  UIKit

struct NewsInfo {
    let newsVideoPreview: String?
    let id: String
    let newsDate: String?
    let newsVideoOriginal: String?
    let newsImageUrl: String?
    let newsName: String?
    let newsDetailedText: String?
    var newsPhotos: [String] = []
    
    init(json: [String: Any]) {
        newsVideoPreview = json["VIDEO_PREVIEW"] as? String ?? ""
        id = json["ID"] as? String ?? ""
        newsDate = json["DISPLAY_ACTIVE_FROM"] as? String ?? ""
        newsVideoOriginal = json["VIDEO_ORIG"] as? String ?? ""
        newsImageUrl = json["DETAIL_PICTURE"] as? String ?? ""
        newsName = json["NAME"] as? String ?? ""
        newsDetailedText = json["DETAIL_TEXT"] as? String ?? ""
        newsPhotos = json["MORE_PHOTO"] as? [String] ?? [""]
    }
}

class NewsDetailedInfoController: UIViewController {
    let cellid = "newsDetailedTextCell"
    
    var newsId: String?
    var newsName: String? = ""
    var newsDate: String? = ""
    var newsImageUrl: String? = ""
    var newsDetailedText: String? = ""
    var newsPhotos: [String]? = []
    
    lazy var collectionViewWidthConstraint: NSLayoutConstraint = {
        let constraint = swipingPhotoView.widthAnchor.constraint(equalTo: view.widthAnchor)
        return constraint
    }()
    
    let newsNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "", size: 14)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let newsDetailedTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let layout = UICollectionViewFlowLayout()
    
    lazy var swipingPhotoView: SwipingPhotoView = {
        let photoView = SwipingPhotoView(frame: view.frame, collectionViewLayout: layout)
        photoView.layout.itemSize = CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }()
    
    var newsInfoNamePlaceholderView1: UIImageView = {
        var newsImageView = UIImageView()
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.image = UIImage(named: "newsinfo_placeholder1")
        return newsImageView
    }()
    
    var newsInfoNamePlaceholderView2: UIImageView = {
        var newsImageView = UIImageView()
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.image = UIImage(named: "newsinfo_placeholder2")
        return newsImageView
    }()
    
    func setupNewsNameLabel() {
        newsNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newsNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 1.8*(navigationController?.navigationBar.frame.height)!).isActive = true
//        newsNameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        newsNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        newsNameLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
       
        view.addSubview(newsInfoNamePlaceholderView1)
        newsInfoNamePlaceholderView1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //newsInfoNamePlaceholderView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 1.5*(navigationController?.navigationBar.frame.height)!).isActive = true
        newsInfoNamePlaceholderView1.topAnchor.constraint(equalTo: view.topAnchor)
        newsInfoNamePlaceholderView1.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        newsInfoNamePlaceholderView1.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupSwipingPhotoView() {
        swipingPhotoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        swipingPhotoView.topAnchor.constraint(equalTo: newsNameLabel.bottomAnchor, constant: 10).isActive = true
        collectionViewWidthConstraint.isActive = true
        swipingPhotoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupNewsDetailedTextView() {
        newsDetailedTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newsDetailedTextView.topAnchor.constraint(equalTo: swipingPhotoView.bottomAnchor, constant: 0).isActive = true
        newsDetailedTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        newsDetailedTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(newsInfoNamePlaceholderView2)
        newsInfoNamePlaceholderView2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newsInfoNamePlaceholderView2.topAnchor.constraint(equalTo: swipingPhotoView.bottomAnchor, constant: 0).isActive = true
        newsInfoNamePlaceholderView2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        newsInfoNamePlaceholderView2.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(newsNameLabel)
        setupNewsNameLabel()
        view.addSubview(swipingPhotoView)
        setupSwipingPhotoView()
        
        view.addSubview(newsDetailedTextView)
        setupNewsDetailedTextView()
        
        retrieveNewsInfo(newsID: newsId!)
        
    }
    
    func retrieveNewsInfo(newsID: String) {
        
        let jsonUrlString = "https://ankportal.ru/rest/index.php?get=newsdetail&id=" + newsID
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        let newsInfo = NewsInfo(json: jsonObj)
                        DispatchQueue.main.async {
                            self?.newsName = newsInfo.newsName
                            self?.newsDate = newsInfo.newsDate
                            self?.newsImageUrl = newsInfo.newsImageUrl
                            self?.newsDetailedText = newsInfo.newsDetailedText
                            self?.newsPhotos = newsInfo.newsPhotos
                            self?.title = newsInfo.newsDate
                            self?.newsNameLabel.text = newsInfo.newsName
                            self?.newsDetailedTextView.text = newsInfo.newsDetailedText?.htmlToString
                            self?.swipingPhotoView.countOfPhotos = newsInfo.newsPhotos.count
                            self?.swipingPhotoView.translatesAutoresizingMaskIntoConstraints = false
                            self?.swipingPhotoView.newsPhotos = newsInfo.newsPhotos
                            self?.newsInfoNamePlaceholderView1.isHidden = true
                            self?.newsInfoNamePlaceholderView2.isHidden = true
                            self?.swipingPhotoView.reloadData()
                            self?.swipingPhotoView.layoutIfNeeded()
                            
                        }
                        
                    }
                    
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
    }
    
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

