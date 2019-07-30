//
//  Brand.swift
//  ankportal
//
//  Created by Admin on 03/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

class ANKPortalItem: Codable, CustomStringConvertible {
    var description: String {
        get {
            return name ?? ""
        }
    }
    
    var id: String?
    var name: String?
    var logo: String?
    
    var brands: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "NAME"
        case logo = "LOGO"
        case brands = "BRANDS"
    }
}

class ANKPortalItemSelectable: ANKPortalItem {
    var isSelected: Bool = false
}
