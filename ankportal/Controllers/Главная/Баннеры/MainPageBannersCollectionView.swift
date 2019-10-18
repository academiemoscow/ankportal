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
    var linkInfo: Link
    
    struct Link {
        let urlLink: String
        let tip: String
        var filterInfo: Filter//[String: Any]
        
        struct Filter {
            let name: String?
            let value: String?
            init(json: [String: Any]) {
                name = json["NAME"] as? String ?? ""
                value = json["VALUE"] as? String ?? ""
            }
        }
        
        init(json: [String: Any]) {
            urlLink = String(json["URL"] as? String ?? "")
            tip = json["TYPE"] as? String ?? ""
            
            let filter = json["FILTER"] //as? Filter ?? Filter(json: ["NAME": "", "VALUE": ""])
            filterInfo = Filter(json: ["NAME": "", "VALUE": ""])
            if filter is NSNull {} else {
                if let json = filter as? [String : Any] {
                    filterInfo = Filter(json: json)
                }
            }
        }
    }
    
    init(json: [String: Any]) {
        id = json["ID"] as? Float ?? 0
        name = json["NAME"] as? String ?? ""
        imageUrl = json["DETAIL_PICTURE"] as? String ?? ""

        let link = json["LINK"]
        linkInfo = Link(json: ["URL": "", "TYPE": "", "FILTER": ["NAME": "", "VALUE": ""]  ])
        if link is NSNull {} else {
            linkInfo = Link(json: link as! [String : Any])
        }
    }
}

class MainPageBannersCollectionView: UICollectionViewInTableViewCell {
    var firstRetrieveKey: Bool = true

    private let cellId = "BannerCell"
    private let cellPlaceholderId = "BannerPlaceholderCell"
    var countOfPhotos: Int = 0
    var imageURL: String?
    
    let tlayout = UICollectionViewFlowLayout()
    
    lazy var trestService: ANKRESTService = ANKRESTService(type: .bannersInfo)

    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: tlayout)
        self.backgroundColor = UIColor.backgroundColor
        self.delegate = self
        self.dataSource = self
        self.tlayout.scrollDirection = .horizontal
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.contentInset.left = contentInsetLeftAndRight
        self.contentInset.right = contentInsetLeftAndRight
        decelerationRate = .fast

        self.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        self.register(BannerPlaceholderCollectionViewCell.self, forCellWithReuseIdentifier: self.cellPlaceholderId)

        if bannersInfo.count == 0 {
            retrieveBannersInfo()
        }
        
    }
    
    override var dataIsEmpty: Bool {
        get {
            return bannersInfo.isEmpty
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
        let cellSize = collectionView(self, layout: self.tlayout, sizeForItemAt: currentIndexPath)
        let targetXOffset = CGFloat(currentIndexPath.row) * (cellSize.width + contentInsetLeftAndRight) - (cellSize.width) / 18
        targetContentOffset.pointee = CGPoint(x: targetXOffset, y: 0)
    }
    
    
    
    func retrieveBannersInfo() {
        if bannersInfo.count>0 {return}
        
        trestService.execute (callback: { [weak self] (data, respone, error) in
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
                self!.doReload = false
            } catch let jsonErr {
                print (jsonErr)
                self?.firstRetrieveKey = true
            }
            
            }
        )
    }
    
    override func fetchData() {
        bannersInfo = []
        firstRetrieveKey = true
        retrieveBannersInfo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainPageBannersCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let linkType = bannersInfo[indexPath.row].linkInfo.tip
        let tabBarController = (UIApplication.shared.delegate as! AppDelegate).tabBarController
        if linkType == "BRANDS" {
            if let mainPageController = tabBarController.getMainPageController() {
                let productsVC = ProductsTableViewController()
                productsVC.logoIsHidden = true
                productsVC.optionalRESTFilters = [RESTParameter(filter: .brandId, value: bannersInfo[indexPath.row].linkInfo.filterInfo.value!)]
                mainPageController.navigationController?.pushViewController(productsVC, animated: true)
            }
            
        } else if linkType == "PRODUCTS" && bannersInfo[indexPath.row].linkInfo.filterInfo.name == "SECTION_ID" {
            if let mainPageController = tabBarController.getMainPageController() {
                let productsVC = ProductsTableViewController()
                productsVC.logoIsHidden = true
                productsVC.optionalRESTFilters = [RESTParameter(filter: .sectionId, value: bannersInfo[indexPath.row].linkInfo.filterInfo.value!)]
                mainPageController.navigationController?.pushViewController(productsVC, animated: true)
            }
        }   else if linkType == "PRODUCTS" && bannersInfo[indexPath.row].linkInfo.filterInfo.name == "ID" {
            if let mainPageController = tabBarController.getMainPageController() {
                let productsVC = ProductInfoTableViewController()
                productsVC.productId = bannersInfo[indexPath.row].linkInfo.filterInfo.value!
                mainPageController.navigationController?.pushViewController(productsVC, animated: true)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.9 - contentInsetLeftAndRight, height: collectionView.frame.height - contentInsetLeftAndRight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if bannersInfo.count == 0 {
            return 2 } else {
            return bannersInfo.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if bannersInfo.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellPlaceholderId, for: indexPath) as! BannerPlaceholderCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! BannerCollectionViewCell
            cell.bannerInfo = bannersInfo[indexPath.row]
            cell.fillCellData()
            return cell
        }
        
    }
    
}
