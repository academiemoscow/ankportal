//
//  AnalogsCollectionViewInTableViewCell.swift
//  ankportal
//
//  Created by Олег Рачков on 07/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class AnalogsCollectionViewInTableViewCell: UITableViewCellWithCollectionView {
    lazy var restQueue: RESTRequestsQueue = RESTRequestsQueue()

    let layout = UICollectionViewFlowLayout()
    var mainPageController: UIViewController?
    
    var analogs: [String] = []
    var images: [UIImage] = []
    var imagesUrl: [String] = []
    var names: [String: String] = [:]
    
    lazy var analogsCollectionView: AnalogsCollectionView = {
        let analogs = AnalogsCollectionView(frame: bounds, collectionViewLayout: layout)
        analogs.translatesAutoresizingMaskIntoConstraints = false
        return analogs
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(analogsCollectionView)
        analogsCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        analogsCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        analogsCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        analogsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        analogsCollectionView.analogs = analogs
        if analogs.count > 0 {
            retrieveImages()
        }
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
                        
                        self!.analogsCollectionView.names.updateValue(productsInfo.name, forKey: productsInfo.detailedPictureUrl)
                        
                        if productsInfo.detailedPictureUrl != "" {
                            
                            let imageUrl = productsInfo.detailedPictureUrl
                            
                            if let image = imageCache.object(forKey: imageUrl as AnyObject) as! UIImage? {
                                self!.analogsCollectionView.imagesUrl.append(imageUrl)
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
                                            
                                            self!.analogsCollectionView.imagesUrl.append(imageUrl)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
