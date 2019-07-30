//
//  MainPageBannersCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 22/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import  UIKit

var bannersInfo: [BannerInfo] = []

struct BannerInfo {
    let id: Float?
    let name: String?
    let imageUrl: String?
    let linkUrl: String?
    
    init(json: [String: Any]) {
        id = json["ID"] as? Float ?? 0
        name = json["NAME"] as? String ?? ""
        imageUrl = json["DETAIL_PICTURE"] as? String ?? ""
        linkUrl = json["LINK"] as? String ?? ""
    }
}

class MainPageBannersCollectionView: UICollectionView {
    var firstRetrieveKey: Bool = true

    private let cellId = "BannerCell"
    var countOfPhotos: Int = 0
    var imageURL: String?
    let layout = UICollectionViewFlowLayout()
    
    
    lazy var restService: ANKRESTService = ANKRESTService(type: .bannersInfo)

    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.backgroundColor
        self.delegate = self
        self.dataSource = self
        self.layout.scrollDirection = .horizontal
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentInset.left = contentInsetLeftAndRight
        self.contentInset.right = contentInsetLeftAndRight
        decelerationRate = .fast

        self.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)

        if bannersInfo.count == 0 {
            retrieveBannersInfo()
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
        } else if (currentIndexPath.row < bannersInfo.count) {
            currentIndexPath.row = currentIndexPath.row + 1
            impactGenerator.impactOccurred()
        }
        let cellSize = collectionView(self, layout: self.layout, sizeForItemAt: currentIndexPath)
        let targetXOffset = CGFloat(currentIndexPath.row) * cellSize.width - cellSize.width / 18
        targetContentOffset.pointee = CGPoint(x: targetXOffset, y: 0)
    }
    
    func retrieveBannersInfo() {
        if bannersInfo.count>0 {return}
        
        restService.execute (callback: { [weak self] (data, respone, error) in
            if ( error != nil ) {
                print(error!)
                return
            }
            
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        let banner = BannerInfo(json: jsonObj)
                        if self!.firstRetrieveKey { bannersInfo.append(banner)
                        }
                    }
                    if bannersInfo.count>0 {self?.firstRetrieveKey = false}
                    DispatchQueue.main.async {
                        self?.reloadData()
                        self?.layoutIfNeeded()
                    }
                }
            } catch let jsonErr {
                print (jsonErr)
                self?.firstRetrieveKey = true
            }
            
            }
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainPageBannersCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.9, height: collectionView.frame.height - contentInsetLeftAndRight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if bannersInfo.count == 0 {
            return 2 } else {
            return bannersInfo.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! BannerCollectionViewCell
        
        if bannersInfo.count == 0 { cell.photoImageView.image = nil} else {
            if bannersInfo[indexPath.row].imageUrl != "" {
                
                let imageUrl = bannersInfo[indexPath.row].imageUrl!
                                
                if let image = imageCache.object(forKey: imageUrl as AnyObject) as! UIImage? {
                    DispatchQueue.main.async {
                        cell.photoImageView.image = image
                    }
                } else {
                    let url = URL(string: imageUrl)
                    URLSession.shared.dataTask(with: url!,completionHandler: {(data, result, error) in
                        if data != nil {
                            let image = UIImage(data: data!)

                            var croppedCGImage: CGImage = (image?.cgImage)!
                           
                            croppedCGImage = (image?.cgImage?.cropping(to: CGRect(x: -100, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)))!

                            let croppedImage = UIImage(cgImage: croppedCGImage)
                            
                            imageCache.setObject(croppedImage, forKey: imageUrl as AnyObject)
                            DispatchQueue.main.async {
                                cell.photoImageView.image = croppedImage
                            }
                        }
                    }
                        ).resume()
                }
            }
        }
        
        
        return cell
    }
    
}
