//
//  NewsCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 22/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import  UIKit
import AudioToolbox

var newsDetailedTextCache = NSCache<AnyObject, AnyObject>()

struct NewsInfo {
    let newsVideoPreview: String?
    let id: Float?
    let newsDate: String?
    let newsVideoOriginal: String?
    let newsImageUrl: String?
    let newsName: String?
    let newsDetailedText: String?
    var newsPhotos: [String] = []
    
    init(json: [String: Any]) {
        newsVideoPreview = json["VIDEO_PREVIEW"] as? String ?? ""
        id = json["ID"] as? Float ?? 0
        newsDate = json["DISPLAY_ACTIVE_FROM"] as? String ?? ""
        newsVideoOriginal = json["VIDEO_ORIG"] as? String ?? ""
        newsImageUrl = json["PREVIEW_PICTURE"] as? String ?? ""
        newsName = json["NAME"] as? String ?? ""
        newsDetailedText = json["DETAIL_TEXT"] as? String ?? ""
        newsPhotos = json["MORE_PHOTO"] as? [String] ?? [""]
    }
}

class NewsCollectionView: UICollectionViewInTableViewCell {
    
    private let cellId = "NewsCell"
    private let placeholderCellId = "placeholderCellId"

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
        self.backgroundColor = UIColor.backgroundColor
        self.delegate = self
        self.dataSource = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentInset.left = contentInsetLeftAndRight
        self.contentInset.right = contentInsetLeftAndRight
        self.layout.scrollDirection = .horizontal
        showsHorizontalScrollIndicator = false
        decelerationRate = .fast
        self.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        self.register(EducationInfoPlaceholderCollectionViewCell.self, forCellWithReuseIdentifier: self.placeholderCellId)
    }
    
    override var dataIsEmpty: Bool {
        get {
            return newslist.isEmpty
        }
    }
    
    private var offsetBeforeDragging: CGPoint = CGPoint.zero
    private var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        offsetBeforeDragging = scrollView.contentOffset.x < 0 ? CGPoint(x: 0, y: 0) : scrollView.contentOffset
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard targetContentOffset.pointee.x != offsetBeforeDragging.x else {
            return
        }
        
        if (offsetBeforeDragging.x > targetContentOffset.pointee.x && currentIndexPath.row > 0) {
            currentIndexPath.row = currentIndexPath.row - 1
            impactGenerator.impactOccurred()
        } else if (currentIndexPath.row < newslist.count) {
            currentIndexPath.row = currentIndexPath.row + 1
            impactGenerator.impactOccurred()
        }
        let cellSize = collectionView(self, layout: self.layout, sizeForItemAt: currentIndexPath)
        let targetXOffset = CGFloat(currentIndexPath.row) * cellSize.width - cellSize.width / 18
        targetContentOffset.pointee = CGPoint(x: targetXOffset, y: 0)
    }
    
    
    func retrieveNewsList() {
        let jsonUrlString = "https://ankportal.ru/rest/index2.php?get=newslist&pagesize=" + String(startNewsShowCount)
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
                jsonUrlString = "https://ankportal.ru/rest/index2.php?get=newslist&pagesize=" + String(startNewsShowCount) + "&PAGEN_1=" + String((currentNewsCount / 5)+1) } else {
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
            loadMoreNewsStatus = false
        }
    }
    
    override func fetchData() {
        newslist = []
        currentNewsCount = 0
        loadMoreNewsStatus = false
        firstStep = true
        tmpUrl = ""
        retrieveNewsList()
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
        return CGSize(width: collectionView.frame.width * 0.9 , height: collectionView.frame.height - contentInsetLeftAndRight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if newslist.count > 0 {return newslist.count} else {return 3}
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
            if self.newslist.count > 0  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewsCollectionViewCell
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
                cell.id = String(id)
                cell.newsName = name
                cell.newsDate = date
                cell.textPreview = textPreview
                cell.layoutSubviews()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.placeholderCellId, for: indexPath) as! EducationInfoPlaceholderCollectionViewCell
                return cell
        }

    }
    
}
