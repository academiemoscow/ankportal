
//
//  ProductInfoViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 15/03/2019.
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



class ProductInfoViewController: UIViewController {
    var productId: String?
    lazy var restQueue: RESTRequestsQueue = RESTRequestsQueue()
    var images: [UIImage] = []

    let productPhotoView: UIView = {
        let productPhotoNameView = UIView()
        productPhotoNameView.backgroundColor = UIColor.white
        productPhotoNameView.layer.cornerRadius = 10
        productPhotoNameView.translatesAutoresizingMaskIntoConstraints = false
        return productPhotoNameView
    }()
    
    let photoImageView: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.image = UIImage(named: "doctor")
        photo.layer.cornerRadius = 20
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    
    let productNameLabel: UITextView = {
        let productNameLabel = UITextView()
        productNameLabel.font = UIFont.systemFont(ofSize: 14)
        productNameLabel.isSelectable = false
        productNameLabel.isScrollEnabled = false
        productNameLabel.backgroundColor = backgroundColor
        productNameLabel.textAlignment = NSTextAlignment.left
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return productNameLabel
    }()
    
    let brandLabel: UITextView = {
        let brandLabel = UITextView()
        brandLabel.font = UIFont.boldSystemFont(ofSize: 14)
        brandLabel.isSelectable = false
        brandLabel.isScrollEnabled = false
        brandLabel.backgroundColor = backgroundColor
        brandLabel.text = "Бренд:"
        brandLabel.textAlignment = NSTextAlignment.left
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        return brandLabel
    }()
    let productBrandLabel: UITextView = {
        let productBrandLabel = UITextView()
        productBrandLabel.font = UIFont.systemFont(ofSize: 14)
        productBrandLabel.isSelectable = false
        productBrandLabel.isScrollEnabled = false
        productBrandLabel.backgroundColor = backgroundColor
        productBrandLabel.textAlignment = NSTextAlignment.left
        productBrandLabel.translatesAutoresizingMaskIntoConstraints = false
        return productBrandLabel
    }()
    
    let articleLabel: UITextView = {
        let articleLabel = UITextView()
        articleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        articleLabel.isSelectable = false
        articleLabel.isScrollEnabled = false
        articleLabel.backgroundColor = backgroundColor
        articleLabel.textAlignment = NSTextAlignment.left
        articleLabel.translatesAutoresizingMaskIntoConstraints = false
        return articleLabel
    }()
    let productArticleLabel: UITextView = {
        let productArticleLabel = UITextView()
        productArticleLabel.font = UIFont.systemFont(ofSize: 14)
        productArticleLabel.isSelectable = false
        productArticleLabel.isScrollEnabled = false
        productArticleLabel.backgroundColor = backgroundColor
        productArticleLabel.textAlignment = NSTextAlignment.left
        productArticleLabel.translatesAutoresizingMaskIntoConstraints = false
        return productArticleLabel
    }()
    
    let infoSegmentedController: UISegmentedControl = {
        let infoSegmentedController = UISegmentedControl(items: ["Описание", "Состав"])
        infoSegmentedController.translatesAutoresizingMaskIntoConstraints = false
        infoSegmentedController.selectedSegmentIndex = 0
        infoSegmentedController.tintColor = lightFirmColor
        infoSegmentedController.backgroundColor = backgroundColor
        infoSegmentedController.addTarget(self, action: #selector(segmentChange), for: .valueChanged)
        return infoSegmentedController
    }()
    
    @objc func segmentChange() {
        if infoSegmentedController.selectedSegmentIndex == 0 {
            productSostavTextView.isHidden = true
            productOpisanieTextView.isHidden = false
            analogsLabel.topAnchor.constraint(equalTo: productOpisanieTextView.bottomAnchor).isActive = true
        } else {
            productSostavTextView.isHidden = false
            productOpisanieTextView.isHidden = true
            analogsLabel.topAnchor.constraint(equalTo: productSostavTextView.bottomAnchor).isActive = true
        }
    }
    
    let productOpisanieTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.isEditable = false
        textView.backgroundColor = backgroundColor
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let productSostavTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = backgroundColor
        textView.isHidden = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    let analogsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Похожие товары"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let analogsView: UIView = {
        let analogsView = UIView()
        analogsView.backgroundColor = UIColor.white
        analogsView.translatesAutoresizingMaskIntoConstraints = false
        return(analogsView)
    }()

    
    let analogsCollectionView: AnalogsCollectionView  = {
        let layout = UICollectionViewFlowLayout()
        let analogsCollectionView = AnalogsCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        analogsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return analogsCollectionView
    }()
    
    
    let seminarsView: UIView = {
        let seminarsView = UIView()
        seminarsView.backgroundColor = UIColor.white
        seminarsView.translatesAutoresizingMaskIntoConstraints = false
        return(seminarsView)
    }()
    
    let seminarsCollectionView: ProductSeminarsCollectionView  = {
        let layout = UICollectionViewFlowLayout()
        let seminarsCollectionView = ProductSeminarsCollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        seminarsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return seminarsCollectionView
    }()
    
    func estimateFrame(forText text: String, _ width: CGFloat = 400) -> CGRect {
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = backgroundColor
        self.title = "Товар"
        
        retrieveProductInfo()
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height * 2)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        scrollView.addSubview(productPhotoView)
        productPhotoView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        productPhotoView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        productPhotoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.45).isActive = true
        productPhotoView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.45).isActive = true
        productPhotoView.backgroundColor = UIColor.white
        productPhotoView.layer.shadowColor = UIColor.red.cgColor
        productPhotoView.layer.shadowOpacity = 0.5
        productPhotoView.layer.shadowOffset = CGSize(width: 1, height: 10)
        productPhotoView.layer.shadowRadius = 5
        productPhotoView.layer.shadowPath = UIBezierPath(rect: productPhotoView.bounds).cgPath
        productPhotoView.layer.shouldRasterize = true
        productPhotoView.layer.rasterizationScale = UIScreen.main.scale
        
        scrollView.addSubview(photoImageView)
        photoImageView.centerXAnchor.constraint(equalTo: productPhotoView.centerXAnchor).isActive = true
        photoImageView.centerYAnchor.constraint(equalTo: productPhotoView.centerYAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: productPhotoView.widthAnchor, multiplier: 0.9).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: productPhotoView.heightAnchor,multiplier: 0.9).isActive = true
        
        scrollView.addSubview(productNameLabel)
        productNameLabel.leftAnchor.constraint(equalTo: productPhotoView.rightAnchor, constant: 4).isActive = true
        productNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        productNameLabel.topAnchor.constraint(equalTo: productPhotoView.topAnchor,constant: -5).isActive = true
        productNameLabel.heightAnchor.constraint(equalTo: productPhotoView.heightAnchor, multiplier: 0.5).isActive = true
        
        scrollView.addSubview(brandLabel)
        brandLabel.leftAnchor.constraint(equalTo: productPhotoView.rightAnchor, constant: 4).isActive = true
        brandLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        brandLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor).isActive = true
        brandLabel.heightAnchor.constraint(equalTo: productPhotoView.heightAnchor, multiplier: 0.15).isActive = true
        scrollView.addSubview(productBrandLabel)
        productBrandLabel.leftAnchor.constraint(equalTo: productPhotoView.rightAnchor, constant: 4).isActive = true
        productBrandLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        productBrandLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor,constant: 0).isActive = true
        productBrandLabel.heightAnchor.constraint(equalTo: productPhotoView.heightAnchor, multiplier: 0.3).isActive = true
        
        scrollView.addSubview(infoSegmentedController)
        infoSegmentedController.topAnchor.constraint(equalTo: productPhotoView.bottomAnchor, constant: 10).isActive = true
        infoSegmentedController.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        infoSegmentedController.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        infoSegmentedController.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(productOpisanieTextView)
        productOpisanieTextView.leftAnchor.constraint(equalTo: infoSegmentedController.leftAnchor).isActive = true
        productOpisanieTextView.rightAnchor.constraint(equalTo: infoSegmentedController.rightAnchor).isActive = true
        productOpisanieTextView.topAnchor.constraint(equalTo: infoSegmentedController.bottomAnchor, constant: 4).isActive = true
        //        productOpisanieTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        //        productOpisanieTextView.layer.borderWidth = 1
        scrollView.addSubview(productSostavTextView)
        productSostavTextView.leftAnchor.constraint(equalTo: infoSegmentedController.leftAnchor).isActive = true
        productSostavTextView.rightAnchor.constraint(equalTo: infoSegmentedController.rightAnchor).isActive = true
        productSostavTextView.topAnchor.constraint(equalTo: infoSegmentedController.bottomAnchor, constant: 4).isActive = true
        //productSostavTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)

        view.addSubview(analogsLabel)
        analogsLabel.topAnchor.constraint(equalTo: productOpisanieTextView.bottomAnchor).isActive = true
        analogsLabel.leftAnchor.constraint(equalTo: infoSegmentedController.leftAnchor).isActive = true
        analogsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        analogsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(analogsView)
        analogsView.topAnchor.constraint(equalTo: analogsLabel.bottomAnchor).isActive = true
        analogsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        analogsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        analogsView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        analogsView.addSubview(analogsCollectionView)
        analogsCollectionView.leftAnchor.constraint(equalTo: analogsView.leftAnchor).isActive = true
        analogsCollectionView.topAnchor.constraint(equalTo: analogsView.topAnchor).isActive = true
        analogsCollectionView.rightAnchor.constraint(equalTo: analogsView.rightAnchor).isActive = true
        analogsCollectionView.bottomAnchor.constraint(equalTo: analogsView.bottomAnchor).isActive = true
        
        view.addSubview(seminarsView)
        seminarsView.topAnchor.constraint(equalTo: analogsView.bottomAnchor).isActive = true
        seminarsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        seminarsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        seminarsView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        seminarsView.addSubview(seminarsCollectionView)
        seminarsCollectionView.leftAnchor.constraint(equalTo: seminarsView.leftAnchor).isActive = true
        seminarsCollectionView.topAnchor.constraint(equalTo: seminarsView.topAnchor).isActive = true
        seminarsCollectionView.rightAnchor.constraint(equalTo: seminarsView.rightAnchor).isActive = true
        seminarsCollectionView.bottomAnchor.constraint(equalTo: seminarsView.bottomAnchor).isActive = true
        
    }
    
    func retrieveProductInfo() {
        let jsonUrlString = "https://ankportal.ru/rest/index.php?get=productdetail&id=" + productId! + "&test=Y"
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    let productsInfo = ProductInfo(json: jsonObj)
                    DispatchQueue.main.async {
                        if self != nil {
                            self!.productBrandLabel.text = productsInfo.brandInfo.name
                            self!.productNameLabel.text = self!.productNameLabel.text + " (" + self!.productId! + ")"
                            self!.productOpisanieTextView.text = productsInfo.howToUse.htmlToString
                            self!.productSostavTextView.text = productsInfo.sostav.htmlToString
                            self!.analogsCollectionView.analogs = productsInfo.analogs
                            self!.seminarsCollectionView.seminars = productsInfo.seminars
                            if productsInfo.analogs.count == 0 {
                                self?.analogsLabel.isHidden = true
                                self?.analogsView.isHidden = true
                            } else {
                                self!.retrieveImages()
                            }
                            self!.analogsCollectionView.reloadData()
                            self!.seminarsCollectionView.reloadData()
                        }
                    }
                }
               
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
    }
    
    func retrieveImages() {
        for i in 0...self.analogsCollectionView.analogs.count-1 {
            let request = ANKRESTService(type: .productDetail)
            request.add(parameters: [
                RESTParameter(filter: .id, value: self.analogsCollectionView.analogs[i]),
                RESTParameter(filter: .isTest, value: "Y")
                ])
            restQueue.add(request: request, completion: { [weak self] (data, respone, error) in
                if ( error != nil ) {
                    print(error!)
                    return
                }
                
                do {
                    if let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        let productsInfo = ProductInfo(json: jsonObj)
                        
                        
                        if productsInfo.detailedPictureUrl != "" {
                            
                            let imageUrl = productsInfo.detailedPictureUrl
                            
                            if let image = imageCache.object(forKey: imageUrl as AnyObject) as! UIImage? {
                                self!.analogsCollectionView.images.append(image)
                                DispatchQueue.main.async {
                                    self!.analogsCollectionView.reloadData()
                                }
                            } else {
                                let url = URL(string: imageUrl)
                                URLSession.shared.dataTask(with: url!,completionHandler: {(data, result, error) in
                                    if data != nil {
                                        if self != nil {
                                            let image = UIImage(data: data!)
                                            self!.analogsCollectionView.images.append(image!)
                                            imageCache.setObject(image!, forKey: imageUrl as AnyObject)
                                            DispatchQueue.main.async {
                                                self!.analogsCollectionView.reloadData()
                                            }
                                        }
                                    }
                                }
                                    ).resume()
                            }
                            
                            
                        }
                        
                    }
                } catch let jsonErr {
                    print (jsonErr)
                }
                
                }
            )
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
