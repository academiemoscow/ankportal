//
//  Brand.swift
//  ankportal
//
//  Created by Admin on 03/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

class Brand: Codable {
    var id: String?
    var name: String?
    var logo: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "NAME"
        case logo = "LOGO"
    }
}

class BrandSelectable: Brand {
    var isSelected: Bool = false
}
