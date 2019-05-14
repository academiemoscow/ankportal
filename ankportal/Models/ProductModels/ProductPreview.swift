//
//  Product.swift
//  ankportal
//
//  Created by Admin on 29/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

struct ProductPreview: Codable {
    
    var id: Int
    var name: String
    var previewPicture: String
    var previewText: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "NAME"
        case previewPicture = "PREVIEW_PICTURE"
        case previewText = "PREVIEW_TEXT"
    }
    
}
