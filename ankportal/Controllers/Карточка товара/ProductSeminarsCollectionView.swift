//
//  SeminarsCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 11/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

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

class ProductSeminarsCollectionView: UICollectionView {
    var fullEducationList: [EducationInfoFromJSON] = []
    var educationList: [EducationInfoFromJSON] = []
    var educationListWithoutDate: [EducationInfoFromJSON] = []
    var cityArray: [String] = []
    var typeArray: [String] = []
    var cityFilter: String = "Все города"
    var typeFilter: String = "Все направления"
    var dateFilter: Date = Date()
    var settingsShow = false
    var firstLoadKey = true
    var navigationControllerHeight: CGFloat = 0
    
    var seminars: [ProductInfo.Seminars] = [ProductInfo.Seminars(json: ["ID": "", "NAME": "", "PREVIEW_TEXT": "", "TOWN": "", "DATE": ""])]
    
    private let cellId = "educationInfoCellId"
    
    let layout = UICollectionViewFlowLayout()
    
    lazy var showSettingsButton: UIButton = {
        var showSettingsButton = UIButton()
        showSettingsButton.setImage(UIImage(named: "filter_barbutton"), for: .normal)
        showSettingsButton.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        showSettingsButton.layer.cornerRadius = 23
        let buttonSize:CGFloat = 45
        
        showSettingsButton.layer.frame = CGRect(x: layer.frame.size.width - buttonSize*1.25, y: layer.frame.size.height - buttonSize*3, width: buttonSize, height: buttonSize)
        showSettingsButton.addTarget(self, action: #selector(filter), for: .touchUpInside)
        showSettingsButton.isHidden = true
        return showSettingsButton
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.tintColor = UIColor.black
        return indicator
    }()
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        retrieveEducationsList()
        addSubview(showSettingsButton)
        
        register(EducationInfoCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        contentInset.top = 6
        backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        layout.scrollDirection = .horizontal
        self.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        self.contentInset.left = 10
        self.contentInset.right = 10
        
        let indicatorSize = 500
        addSubview(activityIndicator)
        activityIndicator.layer.frame = CGRect(x: 110, y: 110, width: indicatorSize, height: indicatorSize)
        activityIndicator.startAnimating()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func filter(){
        let vibrationGenerator = UIImpactFeedbackGenerator()
        vibrationGenerator.impactOccurred()
        let educationSettingsController = ProductSeminarsCollectionView()
        educationSettingsController.cityArray = cityArray
        educationSettingsController.typeArray = typeArray
        educationSettingsController.fullEducationList = self.fullEducationList
    }
    
    func retrieveEducationsList() {
        print(seminars[0])
    }
    
}

extension ProductSeminarsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.75, height: collectionView.frame.width * 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if seminars.count == 0 && firstLoadKey {return 2} else
        {return seminars.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellEducation = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! EducationInfoCollectionViewCell

        if seminars.count > 1 {
            self.firstLoadKey = false
            
            cellEducation.activityIndicator.stopAnimating()
            cellEducation.educationDateLabel.text = seminars[indexPath.row].date
            cellEducation.educationCityLabel.text = seminars[indexPath.row].city
            cellEducation.educationInfoTextLabel.text = seminars[indexPath.row].name
            cellEducation.educationId = seminars[indexPath.row].id
            cellEducation.navigationControllerHeight = self.navigationControllerHeight
        
            let jsonUrlString = "https://ankportal.ru/rest/index.php?get=seminardetail&id=" + seminars[indexPath.row].id
            let url: URL = URL(string: jsonUrlString)!
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
                guard let data = data else { return }
                do {
                    if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                        for jsonObj in jsonCollection {
                            if self != nil {
                                let education = EducationDetailedInfo(json: jsonObj)
                                let imageURL = education.doctorInfo.photoURL
                                if let image = imageNewsPhotoCache.object(forKey: imageURL as AnyObject)  {
                                    DispatchQueue.main.async {
                                        cellEducation.photoImageView.image = image as? UIImage
                                    }
                                } else {
                                        if let url = URL(string: imageURL) {
                                            URLSession.shared.dataTask(with: url, completionHandler: {(data, result, error) in
                                                if error != nil {
                                                    print(error!)
                                                    return
                                                }
                                                let image = UIImage(data: data!)
                                                imageNewsPhotoCache.setObject(image!, forKey: imageURL as AnyObject)
                                                DispatchQueue.main.async {
                                                    cellEducation.photoImageView.image = image
                                                }
                                            }).resume()
                                        }
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            if self != nil {
                                collectionView.reloadData()
                            }
                        }
                    }
                } catch let jsonErr {
                    print (jsonErr)
                }
                }.resume()
            
        }
        return cellEducation
    }
    
}
