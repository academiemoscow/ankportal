//
//  FIRImageProvider.swift
//  ankportal
//
//  Created by Admin on 08/02/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import FirebaseStorage

let firImageProvider = FIRImageProvider()

class FIRImageProvider {
    
    var images: [String: UIImage] = [:]
    
    fileprivate init() {
        
    }
    
    public func getImage(forReference ref: String?) -> UIImage? {
        if let ref = ref {
            return images[ref]
        }
        
        return nil
    }
    
    public func setImage(forReference ref: String?, image: UIImage) {
        if let ref = ref {
            images[ref] = image
        }
    }
    
    public func getImage(forReference ref: String, completion: @escaping (UIImage?, Error?) -> Void) -> StorageDownloadTask {
        
        return Storage.storage().reference()
            .child(ref)
            .getData(maxSize: Int64.max) {[unowned self] (data, error) in
                let image: UIImage? = {
                    if let data = data {
                        if let image = UIImage(data: data) {
                            self.images[ref] = image
                            return image
                        }
                    }
                    return nil
                }()
                completion(image, error)
            }
        
    }
    
}
