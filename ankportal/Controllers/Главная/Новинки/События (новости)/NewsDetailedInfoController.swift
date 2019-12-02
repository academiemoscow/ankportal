//
//  NewsDetailedInfoController.swift
//  ankportal
//
//  Created by Олег Рачков on 30/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import  UIKit

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
        label.font = UIFont.defaultFont(ofSize: 14)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 3
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var newsNameTextLabel: UILabel = {
        var newsNameLabel = UILabel()
        newsNameLabel.font = UIFont.defaultFontBold(ofSize: 16)
        newsNameLabel.numberOfLines = 3
        newsNameLabel.textAlignment = NSTextAlignment.center
        newsNameLabel.sizeToFit()
        newsNameLabel.layer.masksToBounds = true
        newsNameLabel.textColor = UIColor.black
        newsNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return newsNameLabel
    }()
    
    let newsDetailedTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.defaultFont(ofSize: 16)
        textView.isEditable = false
        textView.backgroundColor = UIColor.backgroundColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let layout = UICollectionViewFlowLayout()
    
    lazy var swipingPhotoView: SwipingPhotoView = {
        let photoView = SwipingPhotoView(frame: view.frame, collectionViewLayout: layout)
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.newsId = self.newsId!
        photoView.backgroundColor = UIColor.backgroundColor
        photoView.mainPageController = self
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
        newsImageView.image = UIImage(named: "educationText_placeholder")
        return newsImageView
    }()
    
    let blackBackgroundView = UIView()
    
    var photoImageView: UIImageView?
    var zoomImageView = UIImageView()


    func setupSwipingPhotoView() {
        swipingPhotoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        swipingPhotoView.topAnchor.constraint(equalTo: view.topAnchor, constant: ((navigationController?.navigationBar.frame.maxY)!)+contentInsetLeftAndRight).isActive = true
        collectionViewWidthConstraint.isActive = true
        swipingPhotoView.newsDetailedController = self
        swipingPhotoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setupNewsNameLabel() {
        newsNameLabel.topAnchor.constraint(equalTo: swipingPhotoView.bottomAnchor).isActive = true
        newsNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newsNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        newsNameLabel.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        view.addSubview(newsInfoNamePlaceholderView1)
        newsInfoNamePlaceholderView1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newsInfoNamePlaceholderView1.topAnchor.constraint(equalTo: swipingPhotoView.bottomAnchor).isActive = true
        newsInfoNamePlaceholderView1.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        newsInfoNamePlaceholderView1.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    
    func setupNewsDetailedTextView() {
        newsDetailedTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newsDetailedTextView.topAnchor.constraint(equalTo: newsNameLabel.bottomAnchor, constant: contentInsetLeftAndRight).isActive = true
        newsDetailedTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -contentInsetLeftAndRight).isActive = true
        newsDetailedTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(newsInfoNamePlaceholderView2)
        newsInfoNamePlaceholderView2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newsInfoNamePlaceholderView2.topAnchor.constraint(equalTo: newsNameLabel.bottomAnchor, constant: 0).isActive = true
        newsInfoNamePlaceholderView2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -contentInsetLeftAndRight).isActive = true
        newsInfoNamePlaceholderView2.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor

        view.addSubview(swipingPhotoView)
        
        setupSwipingPhotoView()

        view.addSubview(newsNameLabel)
        newsNameTextLabel.text = newsName
        
        newsNameLabel.addSubview(newsNameTextLabel)
        newsNameTextLabel.bottomAnchor.constraint(equalTo: newsNameLabel.bottomAnchor).isActive = true
        newsNameTextLabel.widthAnchor.constraint(equalTo: newsNameLabel.widthAnchor).isActive = true
        newsNameTextLabel.heightAnchor.constraint(equalTo: newsNameLabel.heightAnchor, multiplier: 0.5).isActive = true
        newsNameTextLabel.centerXAnchor.constraint(equalTo: newsNameLabel.centerXAnchor).isActive = true
        
        view.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: newsNameLabel.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: newsNameLabel.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        separatorView.rightAnchor.constraint(equalTo: newsNameLabel.rightAnchor, constant: -contentInsetLeftAndRight).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        setupNewsNameLabel()
                view.addSubview(newsDetailedTextView)
        setupNewsDetailedTextView()
        
        retrieveNewsInfo(newsID: newsId!)
    }
    
    func retrieveNewsInfo(newsID: String) {
        let jsonUrlString = "https://ankportal.ru/rest/index2.php?get=newsdetail&id=" + newsID
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
                            self?.title = newsInfo.newsDate
                            self?.newsImageUrl = newsInfo.newsImageUrl
                            self?.newsDetailedText = newsInfo.newsDetailedText
                            self?.newsPhotos = newsInfo.newsPhotos
                            self?.newsPhotos?.insert(newsInfo.newsImageUrl!, at: 0)
                            self?.newsNameTextLabel.text = newsInfo.newsName
                            self?.newsDetailedTextView.text = newsInfo.newsDetailedText?.htmlToString
                            self?.swipingPhotoView.countOfPhotos = newsInfo.newsPhotos.count
                            self?.swipingPhotoView.translatesAutoresizingMaskIntoConstraints = false
                            self?.swipingPhotoView.newsPhotos = newsInfo.newsPhotos
                            self?.swipingPhotoView.newsPhotos.append(newsInfo.newsImageUrl!)
                            self?.swipingPhotoView.newsName = newsInfo.newsName!
                            self?.newsInfoNamePlaceholderView1.isHidden = true
                            self?.newsInfoNamePlaceholderView2.isHidden = true
                        }
                    }
                    DispatchQueue.main.async {
                        self?.swipingPhotoView.reloadData()
                        self?.swipingPhotoView.layoutIfNeeded()
                    }
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
    }
    

   
    override func viewWillAppear(_ animated: Bool) {
        self.title = newsDate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = newsDate
    }
    
}


