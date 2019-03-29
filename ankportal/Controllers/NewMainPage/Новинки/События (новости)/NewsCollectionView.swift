//
//  NewsCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 22/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import  UIKit

var newsDetailedTextCache = NSCache<AnyObject, AnyObject>()

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

class NewsCollectionView: UICollectionView {
    
    private let cellId = "NewsCell"
    var countOfPhotos: Int = 0
    var imageURL: String?
    let layout = UICollectionViewFlowLayout()
    
    var newslist: [NewsList] = []
    let startNewsShowCount: Int = 5
    var currentNewsCount = 0
    var loadMoreNewsStatus: Bool = false
    var firstStep: Bool = true
    
    var tmpUrl: String = ""
    
    var ip:CGFloat = 0
    
    var mainPageController: UIViewController?
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        retrieveNewsList()
        self.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        self.delegate = self
        self.dataSource = self
        self.layout.scrollDirection = .horizontal
        self.contentInset.right = frame.width*0.025
        
        self.isPagingEnabled = true
        self.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
    }
    
    func retrieveNewsList() {
        let jsonUrlString = "https://ankportal.ru/rest/index.php?get=newslist&pagesize=" + String(startNewsShowCount)
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        let news = NewsList(json: jsonObj)
                        self?.newslist.append(news)
                        self!.currentNewsCount+=1
                    }
                    self?.loadMoreNewsToShow()
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
    }
    
    
    func loadMoreNewsToShow(){
        var jsonUrlString: String = ""
        if (!loadMoreNewsStatus)  {
            loadMoreNewsStatus = true
            if currentNewsCount>0 {
                jsonUrlString = "https://ankportal.ru/rest/index.php?get=newslist&pagesize=" + String(startNewsShowCount) + "&PAGEN_1=" + String((currentNewsCount / 5)+1) } else {
                loadMoreNewsStatus = false
                return
            }
            if tmpUrl == jsonUrlString {
                loadMoreNewsStatus = false
                return
            }
            tmpUrl = jsonUrlString
            guard let url: URL = URL(string: jsonUrlString) else {return}
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
                guard let data = data else { return }
                do {
                    if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                        for jsonObj in jsonCollection {
                            let news = NewsList(json: jsonObj)
                            self?.newslist.append(news)
                            self?.currentNewsCount+=1
                        }
                    }
                } catch let jsonErr {
                    print (jsonErr)
                }
                }.resume()
            
            DispatchQueue.main.async {
                self.reloadData()
            }
            self.loadMoreNewsStatus = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NewsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.x
        let maximumOffset = scrollView.contentSize.width - scrollView.frame.size.width
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 {
            loadMoreNewsToShow()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height*0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if newslist.count > 0 {return newslist.count} else {return 3}
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewsCollectionViewCell
            if self.newslist.count > 0  {
                let news = self.newslist[indexPath.row]
                let imageURL = news.imageURL
                let id = news.id
                let name = news.name
                let date = news.date
                let textPreview = news.textPreview
                cell.mainPageController = mainPageController
                cell.photoImageView.image = nil
                if let image = imageNewsPhotoCache.object(forKey: imageURL as AnyObject)  {
                    cell.photoImageView.image = image as? UIImage
                } else {
                    if imageURL != nil {
                        if let url = URL(string: imageURL!) {
                            URLSession.shared.dataTask(with: url, completionHandler: {(data, result, error) in
                                if error != nil {
                                    print(error!)
                                    return
                                }
                                let image = UIImage(data: data!)
                                imageNewsPhotoCache.setObject(image!, forKey: imageURL as AnyObject)
                                DispatchQueue.main.async {
                                    self.reloadData()
                                }
                            }).resume()
                        }
                    }
                }
                cell.id = id
                cell.newsName = name
                cell.newsDate = date
                cell.textPreview = textPreview
                cell.layoutSubviews()
        }
        return cell
    }
    
}
