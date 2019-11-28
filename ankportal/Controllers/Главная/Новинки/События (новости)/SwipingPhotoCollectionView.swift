//
//  SwipingPhotoController.swift
//  ankportal
//
//  Created by Олег Рачков on 31/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import  UIKit

var imageNewsPhotosCache = NSCache<AnyObject, AnyObject>()

class SwipingPhotoView: UICollectionView {
    
    private let cellId = "newsDetailedTextCell"
    var countOfPhotos: Int = 0
    var imageURL: String?
    var newsPhotos: [String] = []
    var newsName: String = ""
    var newsId: String = ""
    var mainPageController: NewsDetailedInfoController?
    let layout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        contentInset.left = 00
        contentInset.right = 10
        
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.layout.scrollDirection = .horizontal
        self.layout.minimumLineSpacing = 10
        layer.cornerRadius = 10
        self.register(NewsDetailedTextCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoGalleryController = ShowPhotoGalleryCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        photoGalleryController.newsId = self.newsId
        photoGalleryController.startPhotoNum = indexPath.row
        photoGalleryController.newsName = newsName
        photoGalleryController.newsDate = mainPageController?.newsDate
        self.mainPageController?.navigationController?.pushViewController(photoGalleryController, animated: true)
    }
    
    var newsDetailedController: NewsDetailedInfoController?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SwipingPhotoView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.countOfPhotos == 0 {return 5} else {return self.countOfPhotos}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewsDetailedTextCollectionViewCell
        cell.frame.size.height = self.frame.size.height - 10
        cell.photoImageView.image = nil
        cell.activityIndicator.startAnimating()
        if newsPhotos.count == 0 {return cell}
        
        if let image = imageNewsPhotosCache.object(forKey: newsPhotos[indexPath.row] as AnyObject) as! UIImage? {
            cell.photoImageView.image = image
            cell.activityIndicator.stopAnimating()
        }
            else if self.countOfPhotos > 0 {
            if newsPhotos[indexPath.row] != "" {
                let url = URL(string: newsPhotos[indexPath.row])!
                URLSession.shared.dataTask(with: url,completionHandler: {(data, result, error) in
                    if data != nil{
                    let image = UIImage(data: data!)
                    imageNewsPhotosCache.setObject(image!, forKey: self.newsPhotos[indexPath.row] as AnyObject)
                        DispatchQueue.main.async {
                            cell.photoImageView.image = image
                            cell.activityIndicator.stopAnimating()
                        }
                    }
                }).resume()}
        }
        return cell
    }
    
    
}
