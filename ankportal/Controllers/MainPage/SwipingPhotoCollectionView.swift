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
    
    let layout = UICollectionViewFlowLayout()
    
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.layout.scrollDirection = .horizontal
        self.layout.minimumLineSpacing = 10
        self.register(NewsDetailedTextCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SwipingPhotoView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.countOfPhotos == 0 {return 10} else {return self.countOfPhotos}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewsDetailedTextCollectionViewCell
        cell.frame.size.height = 150
        cell.photoImageView.image = nil
        
        if let image = imageNewsPhotosCache.object(forKey: imageURL as AnyObject) as! UIImage? {
            cell.photoImageView.image = image
            cell.activityIndicator.stopAnimating()
        }
            else if self.countOfPhotos > 0 {
            if newsPhotos[indexPath.row]>"" {
                let url = URL(string: newsPhotos[indexPath.row])!
                URLSession.shared.dataTask(with: url,completionHandler: {(data, result, error) in
                    let image = UIImage(data: data!)
                   imageNewsPhotosCache.setObject(image!, forKey: self.imageURL as AnyObject)
                    DispatchQueue.main.async {
                        cell.photoImageView.image = image
                        cell.activityIndicator.stopAnimating()
                    }
                }).resume()}
        }
        
        return cell
    }
    
    
    
}
