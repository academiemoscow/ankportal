//
//  ProductInfoTableViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 02/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit
struct ProductInfo {
    let id: String
    let name: String
    let detailedPictureUrl: String
    let detailText: String
    let price: CGFloat
    let article: String
    var brandInfo: BrandInfo
    
    struct BrandInfo {
        let id: CGFloat
        let name: String
        var detailedPictureUrl: String
        let detailText: String
        let logoUrl: String
        let note: String
        let country: String
        init(json: [String: Any]) {
            id = json["ID"] as? CGFloat ?? 0
            name = json["NAME"] as? String ?? ""
            detailedPictureUrl = json["DETAIL_PICTURE"] as? String ?? ""
            detailText = json["DETAIL_TEXT"] as? String ?? ""
            logoUrl = json["LOGO"] as? String ?? ""
            note = json["NOTE"] as? String ?? ""
            country = json["COUNTRY"] as? String ?? ""
        }
    }
    let isNew: String
    let isNew2: String
    let howToUse: String
    let sostav: String
    let upakovka: String
    let isSale: String
    let isHit: String
    
    let anotherPhotos: [String]
    let line: String
    let analogs: [String]
    let items: Bool
    let remain: CGFloat
    let avaible: String
    var seminars: [Seminars]
    struct Seminars {
        let id: String
        let name: String
        var previewText: String
        let city: String
        let date: String
        init(json: [String: Any]) {
            id = json["ID"] as? String ?? ""
            name = json["NAME"] as? String ?? ""
            previewText = json["PREVIEW_TEXT"] as? String ?? ""
            city = json["TOWN"] as? String ?? ""
            date = json["DATE"] as? String ?? ""
        }
    }
    
    init(json: [String: Any]) {
        id = json["ID"] as? String ?? ""
        name = json["NAME"] as? String ?? ""
        detailedPictureUrl = json["DETAIL_PICTURE"] as? String ?? ""
        detailText = json["DETAIL_TEXT"] as? String ?? ""
        price = json["PRICE"] as? CGFloat ?? 0
        article = json["ARTICLE"] as? String ?? ""
        
        let brand = json["BRAND"]
        brandInfo = BrandInfo(json: ["ID": "", "NAME": "", "DETAIL_PICTURE": "", "DETAIL_TEXT": "", "LOGO": "", "NOTE": "", "COUNTRY": ""])
        if brand is NSNull {} else {
            brandInfo = BrandInfo(json: brand as! [String : Any])
        }
        
        isNew = json["IS_NEW"] as? String ?? ""
        isNew2 = json["IS_NEW2"] as? String ?? ""
        howToUse = json["KAK_POLZOVATSIAY"] as? String ?? ""
        sostav = json["SOSTAV"] as? String ?? ""
        upakovka = json["UPAKOVKA"] as? String ?? ""
        isSale = json["IS_NEW"] as? String ?? ""
        isHit = json["IS_NEW2"] as? String ?? ""
        anotherPhotos = json["IS_NEW2"] as? [String] ?? []
        line = json["KAK_POLZOVATSIAY"] as? String ?? ""
        analogs = json["ANALOGS_ID"] as? [String] ?? []
        items = json["UPAKOVKA"] as? Bool ?? false
        remain = json["SALE"] as? CGFloat ?? 0
        avaible = json["HIT"] as? String ?? ""
        
        seminars = [Seminars(json: ["ID": "", "NAME": "", "PREVIEW_TEXT": "", "TOWN": "", "DATE": ""])]
        let seminars_array = json["SEMINARS"]
        if seminars_array is NSNull {} else {
            let seminars_array = json["SEMINARS"] as! NSArray
            if seminars_array.count > 0 {
                seminars = []
                for seminar in seminars_array {
                    seminars.append(Seminars(json: seminar as! [String : Any]))
                }
            }
        }
        
    }
}

class ProductInfoTableViewController: UIViewController {
    
    var productId: String = ""
    var productsInfo: ProductInfo?
    
    let screenSize = UIScreen.main.bounds
    
    var paralaxTableView: ParalaxHeaderTableView = {
        let containerView = UIView()
        let tableView = ParalaxHeaderTableView(headerView: containerView)
        return tableView
    }()
    
    let priceAndCartCell = "priceAndCartCell" // цена и добавление в корзину
    let productNameAndBrandCell = "productNameAndBrandCell" // название и бренл
    let productDescriptionCell = "productDescriptionCell" // описание
    let productCompositionCell = "productCompositionCell" // состав
    let analogsCell = "analogsCell" // похожие товары
    
    var productNameAndBrandCellHeight: CGFloat = 0
    var productDescriptionCellHeight: CGFloat = 0
    var productCompositionCellHeight: CGFloat = 0

    var desctriptionText: String = ""
    var compositionText: String = ""

    lazy var navBarMaxY: CGFloat = self.navigationController?.navigationBar.frame.maxY ?? 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        paralaxTableView.dataSource = self
        paralaxTableView.delegate = self
        
        paralaxTableView.translatesAutoresizingMaskIntoConstraints = false
        
        //регистрация классов ячеек
        paralaxTableView.register(PriceAndButtonToCartTableViewCell.self, forCellReuseIdentifier: priceAndCartCell)
        
        paralaxTableView.register(ProductNameAndBrandTableViewCell.self, forCellReuseIdentifier: productNameAndBrandCell)
        paralaxTableView.register(ProductDescriptionTableViewCell.self, forCellReuseIdentifier: productDescriptionCell)
        paralaxTableView.register(ProductCompositionTableViewCell.self, forCellReuseIdentifier: productCompositionCell)

        paralaxTableView.register(AnalogsCollectionViewInTableViewCell.self, forCellReuseIdentifier: analogsCell)

        
        view.addSubview(paralaxTableView)
        paralaxTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        paralaxTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        paralaxTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        paralaxTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paralaxTableView.headerHeight = UIScreen.main.bounds.height / 2
        
        productPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        paralaxTableView.headerView.addSubview(productPhotoImageView)
        productPhotoImageView.topAnchor.constraint(equalTo: paralaxTableView.headerView.topAnchor).isActive = true
        productPhotoImageView.bottomAnchor.constraint(equalTo: paralaxTableView.headerView.bottomAnchor).isActive = true
        productPhotoImageView.widthAnchor.constraint(equalTo: paralaxTableView.headerView.widthAnchor).isActive = true
        productPhotoImageView.leftAnchor.constraint(equalTo: paralaxTableView.headerView.leftAnchor).isActive = true
        
        paralaxTableView.headerView.addSubview(brandImageContainer)
        
        brandImageContainer.topAnchor.constraint(
            equalTo: paralaxTableView.headerView.topAnchor,
            constant: contentInsetLeftAndRight + navBarMaxY
        ).isActive = true
        brandImageContainer.rightAnchor.constraint(
            equalTo: paralaxTableView.headerView.rightAnchor,
            constant: -contentInsetLeftAndRight
        ).isActive = true
        brandImageContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        brandImageContainer.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        retrieveProductInfo()
    }
    
    let productNameLabel: UILabel = {
        let productNameLabel = UILabel()
        productNameLabel.text = ""
        productNameLabel.numberOfLines = 3
        productNameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return(productNameLabel)
    }()
    
    lazy var brandImageContainer: UIPillShadowView = {
        let view = UIPillShadowView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brandImage)
        brandImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        brandImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        brandImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        brandImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    let brandImage: ImageLoader = {
        let imageView = ImageLoader()
        imageView.tintColor = UIColor.lightGray
        imageView.emptyImage = nil
        imageView.transformImage = { (image) in
            return image.cropping(to: UIImage.ImageRegion.bottomHalf)
        }
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    let productPhotoImageView: ImageLoader = {
        let photo = ImageLoader()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.sizeToFit()
        photo.isUserInteractionEnabled = true
        return photo
    }()
    
    func retrieveProductInfo() {
        let jsonUrlString = "https://ankportal.ru/rest/index.php?get=productdetail&id=" + productId + "&test=Y"
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    self!.productsInfo = ProductInfo(json: jsonObj)
                    DispatchQueue.main.async {
                        if self != nil {
                            
                            self!.productNameLabel.text = self!.productsInfo?.name
                            let productName = self!.productsInfo?.name
                            self!.title = productName
                            
                            self!.brandImage.loadImageWithUrl(URL(string: (self!.productsInfo?.brandInfo.logoUrl)!)!)
                            
                            self!.productPhotoImageView.loadImageWithUrl(URL(string: self!.productsInfo!.detailedPictureUrl)!)
                            
                            let priceAndCartCell = self!.paralaxTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PriceAndButtonToCartTableViewCell
                            let price = String(Float(self!.productsInfo!.price))
                            priceAndCartCell?.priceLabel.text = price + " RUB"
                            if self!.productsInfo?.article == "" {
                                priceAndCartCell?.articleLabel.text = "арт. -"
                            } else {
                                priceAndCartCell?.articleLabel.text = "арт." + self!.productsInfo!.article
                            }
                            
                            
                            let productNameAndBrandCell = self!.paralaxTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ProductNameAndBrandTableViewCell
                            productNameAndBrandCell?.productNameLabel.text = productName
                            
                            let descriptionCell = self!.paralaxTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? ProductDescriptionTableViewCell
                            descriptionCell?.productDescriptionTextView.text = self?.productsInfo?.howToUse.htmlToString
                            
                            let compositionCell = self!.paralaxTableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? ProductCompositionTableViewCell
                            if self?.productsInfo?.sostav.htmlToString != "" {
                                compositionCell?.productCompositionTextView.text = (self?.productsInfo?.sostav.htmlToString)!
                                } else {
                                compositionCell?.productCompositionTextView.text = "-"
                            }
                            
                            let textWidth = (productNameAndBrandCell?.productNameLabel.frame.size.width)! - contentInsetLeftAndRight*2
                        
                            self!.productNameAndBrandCellHeight =
                                self!.estimateFrame(forText: self!.productsInfo!.name, textWidth, fontSize: 18).height
                                + contentInsetLeftAndRight * 2
                            
                            self!.productDescriptionCellHeight = self!.estimateFrame(forText: self!.productsInfo!.howToUse.htmlToString, textWidth, fontSize: 12).height + contentInsetLeftAndRight * 2
                            
                            self!.productCompositionCellHeight = self!.estimateFrame(forText: self!.productsInfo!.sostav.htmlToString, textWidth, fontSize: 12).height + contentInsetLeftAndRight * 3
                            
                            let analogsCell = self!.paralaxTableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? AnalogsCollectionViewInTableViewCell
                            analogsCell?.analogs = (self?.productsInfo!.analogs)!
                            analogsCell?.analogsCollectionView.mainPageController = analogsCell
                            analogsCell?.collectionView.reloadData()
                            self!.paralaxTableView.reloadData()
                            
                        }
                    }
                }
                
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
    }
    
    
    func estimateFrame(forText text: String, _ width: CGFloat = 200, fontSize: CGFloat) -> CGRect {
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
    }


}


extension ProductInfoTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        case 1:
            return productNameAndBrandCellHeight
        case 2:
            return productDescriptionCellHeight
        case 3:
            return productCompositionCellHeight
        case 4:
            if self.productsInfo?.analogs.count == 0 {
                return 0
            } else {
                return screenSize.height * 0.2 }
        default:
            return 300
        }
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 2:
            return 20
        case 3:
            return 20
        case 4:
            if self.productsInfo?.analogs.count == 0 {
                return 0
            } else {
                return 20 }
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sectionName: String = ""
        var sectionNameFontSize: CGFloat = 14
        var sectionHeight: CGFloat = 20
        
        switch section {
        case 2:
            sectionName = "Описание"
        case 3:
            sectionName = "Состав"
        case 4:
            sectionName = "Похожие и сопутствующие товары"
        default:
            sectionName = ""
            sectionNameFontSize = 0
            sectionHeight = 0
        }
        
        let sectionView = createHeaderSectionView(sectionName: sectionName, fontSize: sectionNameFontSize, height: sectionHeight)
        
        return sectionView
        
    }

    
    fileprivate func createHeaderSectionView(sectionName: String, fontSize: CGFloat, height: CGFloat) -> UIView {
        let sectionView = UIView()
        sectionView.backgroundColor = UIColor.backgroundColor
        
        let nameLabel = createSectionNameLabel(sectionName: sectionName, fontSize: fontSize)
        sectionView.addSubview(nameLabel)
        setSectionNameLabel(sectionNameLabel: nameLabel, parentView: sectionView, height: height)
        return sectionView
    }
    
    fileprivate func createSectionNameLabel(sectionName: String, fontSize: CGFloat) -> UILabel {
        let sectionNameLabel = UILabel()
        sectionNameLabel.text = sectionName
        sectionNameLabel.font = UIFont.defaultFont(ofSize: fontSize)
        sectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return sectionNameLabel
    }
    
    fileprivate func setSectionNameLabel (sectionNameLabel: UILabel, parentView: UIView, height: CGFloat) {
        sectionNameLabel.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        sectionNameLabel.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        sectionNameLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = paralaxTableView.dequeueReusableCell(withIdentifier: priceAndCartCell, for: indexPath) as! PriceAndButtonToCartTableViewCell
            return cell
        case 1:
        let cell = paralaxTableView.dequeueReusableCell(withIdentifier: productNameAndBrandCell, for: indexPath) as! ProductNameAndBrandTableViewCell
        return cell
        case 2:
            let cell = paralaxTableView.dequeueReusableCell(withIdentifier: productDescriptionCell, for: indexPath) as! ProductDescriptionTableViewCell
            return cell
        case 3:
            let cell = paralaxTableView.dequeueReusableCell(withIdentifier: productCompositionCell, for: indexPath) as! ProductCompositionTableViewCell
            return cell
        case 4:
            let cell = paralaxTableView.dequeueReusableCell(withIdentifier: analogsCell, for: indexPath) as! AnalogsCollectionViewInTableViewCell
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
    
}
