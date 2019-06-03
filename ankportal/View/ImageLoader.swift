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
    
    var activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView()
    var transformImage: ((UIImage) -> (UIImage)) = { $0 }
    
    func loadImageWithUrl(_ url: URL) {
        
        setupActivityIndicator()
        
        imageURL = url
        
        image = nil
        activityIndicator?.startAnimating()
        if (setImageFromCache(withURL: url) == true) {
            return
        }
        
        cacheAndSetImage(fromURL: url)
    }
    
    func setupActivityIndicator() {
        if let activityIndicator = activityIndicator {
            activityIndicator.color = .darkGray
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            addSubview(activityIndicator)
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
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
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self.activityIndicator?.stopAnimating()
                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    let transformedImage = self.transformImage(imageToCache)
                    
                    if self.imageURL == url {
                        self.image = transformedImage
                    }
                    
                    imageCache.setObject(transformedImage, forKey: url as AnyObject)
                }
                self.activityIndicator?.stopAnimating()
            })
        }).resume()
    }
}
