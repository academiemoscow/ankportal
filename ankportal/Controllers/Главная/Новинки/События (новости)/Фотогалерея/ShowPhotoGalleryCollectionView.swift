//
//  ShowPhotoGalleryCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 04/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class ShowPhotoGalleryCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "photoGalerryCell"
    var newsId: String?
    var newsName: String? = ""
    var newsDate: String? = ""
    var newsImageUrl: String? = ""
    var newsDetailedText: String? = ""
    var newsPhotos: [String]? = []
    var startPhotoNum: Int = 0
    var startPhotoDidShow = false
    var countOfPhotos: Int = 0
    let layout = UICollectionViewFlowLayout()
    
    var newsNameLabel: UILabel = {
        var newsNameLabel = UILabel()
        newsNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        newsNameLabel.numberOfLines = 3
        newsNameLabel.backgroundColor = UIColor.ankPurple
        newsNameLabel.textAlignment = NSTextAlignment.left
        newsNameLabel.sizeToFit()
        newsNameLabel.layer.masksToBounds = true
        newsNameLabel.layer.cornerRadius = 10
        newsNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return newsNameLabel
    }()
    
    var newsNameTextLabel: UILabel = {
        var newsNameLabel = UILabel()
        newsNameLabel.font = UIFont.defaultFont(ofSize: 16)
        newsNameLabel.numberOfLines = 3
        newsNameLabel.backgroundColor = UIColor.ankPurple
        newsNameLabel.textAlignment = NSTextAlignment.center
        newsNameLabel.sizeToFit()
        newsNameLabel.layer.masksToBounds = true
        newsNameLabel.textColor = UIColor.black
        newsNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return newsNameLabel
    }()
    
    @objc func backBarButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = ""

        
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(PhotoGalleryCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
      
        self.title = newsDate
        view.addSubview(newsNameLabel)
        newsNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: (navigationController?.navigationBar.frame.midY)!/2-10).isActive = true
        newsNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newsNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -contentInsetLeftAndRight*2).isActive = true
        newsNameLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        newsNameTextLabel.text = newsName
        newsNameLabel.addSubview(newsNameTextLabel)
        newsNameTextLabel.bottomAnchor.constraint(equalTo: newsNameLabel.bottomAnchor).isActive = true
        newsNameTextLabel.widthAnchor.constraint(equalTo: newsNameLabel.widthAnchor).isActive = true
        newsNameTextLabel.heightAnchor.constraint(equalTo: newsNameLabel.heightAnchor, multiplier: 0.5).isActive = true
        newsNameTextLabel.centerXAnchor.constraint(equalTo: newsNameLabel.centerXAnchor).isActive = true
        
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoGalleryCollectionViewCell
        cell.photoImageView.image = nil
        cell.mainPageController = self

        cell.configure(photoUrl: newsPhotos![indexPath.row])
        if !startPhotoDidShow && startPhotoNum <= (self.newsPhotos?.count)! {
            collectionView.scrollToItem(at: [0, startPhotoNum], at: .left, animated: false)
            startPhotoDidShow = true
        }
        return cell
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newsPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
