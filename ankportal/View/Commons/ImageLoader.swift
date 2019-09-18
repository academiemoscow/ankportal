//
//  ImageLoader.swift
//  ankportal
//
//  Created by Admin on 16/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class ImageLoader: UIImageView {
    
    var imageURL: URL?
    
    lazy var activityIndicator: UIActivityIndicatorView? = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        return activityIndicator
    }()
    
    var emptyImage: UIImage? = UIImage.placeholder
    
    var transformImage: ((UIImage) -> (UIImage)) = { $0 }
    
    func loadImageWithUrl(_ url: URL) {
        imageURL = url
        
        image = nil
        activityIndicator?.startAnimating()
        if (setImageFromCache(withURL: url) == true) {
            return
        }
        
        cacheAndSetImage(fromURL: url)
    }
    
    func setImageFromCache(withURL url: URL) -> Bool {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            activityIndicator?.stopAnimating()
            return true
        }
        return false
    }
    
    func cacheAndSetImage(fromURL url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                print(error as Any)
//                DispatchQueue.main.async(execute: {
//                    self?.image = self?.emptyImage
//                    self?.activityIndicator?.stopAnimating()
//                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                
//                self?.image = self?.emptyImage
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    guard let transformedImage = self?.transformImage(imageToCache) else {
                        return
                    }
                    
                    if self?.imageURL == url {
                        self?.image = transformedImage
                    }
                    
                    imageCache.setObject(transformedImage, forKey: url as AnyObject)
                }
                self?.activityIndicator?.stopAnimating()
            })
        }).resume()
    }
}
