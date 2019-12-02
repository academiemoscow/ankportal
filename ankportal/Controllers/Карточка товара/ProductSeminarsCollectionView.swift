//
//  SeminarsCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 11/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit


class ProductSeminarsCollectionView: UICollectionViewInTableViewCell {
    var mainPageController: ProductSeminarsCollectionViewInTableViewCell?

    lazy var restQueue: RESTRequestsQueue = RESTRequestsQueue()

    var data: [EducationPreview] = []
    
    var educationsArray: [String] = []
    
    private let cellId = "educationInfoCellId"
    private let placeholderCellId = "placeholderEducationInfoCellId"
    
    let layout = UICollectionViewFlowLayout()
    
    lazy var showSettingsButton: UIButton = {
        var showSettingsButton = UIButton()
        showSettingsButton.setImage(UIImage(named: "filter_barbutton"), for: .normal)
        showSettingsButton.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        showSettingsButton.layer.cornerRadius = 23
        let buttonSize:CGFloat = 45
        
        showSettingsButton.layer.frame = CGRect(x: layer.frame.size.width - buttonSize*1.25, y: layer.frame.size.height - buttonSize*3, width: buttonSize, height: buttonSize)
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
        
        addSubview(showSettingsButton)
        
        register(EducationInfoCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        register(EducationInfoPlaceholderCollectionViewCell.self, forCellWithReuseIdentifier: self.placeholderCellId)
        backgroundColor = UIColor.white
        delegate = self
        dataSource = self
        layout.scrollDirection = .horizontal
        contentInset.left = contentInsetLeftAndRight
        contentInset.right = contentInsetLeftAndRight
    }
    
    func retrieveEducationsData() {
        let request = ANKRESTService(type: .educationList)
        request.add(parameters: (educationsArray.mapToRESTParameters(forRESTFilter: .fid)))
        restQueue.add(request: request) {[weak self] (data, response, error) in
            guard let data = data else {
                return
            }
            if let data = try? JSONDecoder().decode([EducationPreview].self, from: data) {
                self?.data = data
                DispatchQueue.main.async {
                    self?.reloadData()
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProductSeminarsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.95, height: collectionView.frame.height * 0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if data.count == 0 { return 3 }
        else {return data.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if (data.count == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: placeholderCellId, for: indexPath) as! EducationInfoPlaceholderCollectionViewCell
            return cell
        } else {
        
        let cellEducation = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! EducationInfoCollectionViewCell
        cellEducation.educationInfo = EducationInfoCell()
        cellEducation.educationInfo?.educationInfoFromJSON = data[indexPath.row]
        cellEducation.fillCellData()
        
            return cellEducation }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedInfoViewController = EducationDetailedInfoController()
        detailedInfoViewController.educationId = data[indexPath.row].id
        
        firstPageController?.navigationController?.pushViewController(detailedInfoViewController, animated: true)
    }
    
}
