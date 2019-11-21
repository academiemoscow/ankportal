//
//  Product.swift
//  ankportal
//
//  Created by Admin on 20/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

struct Product: Codable {
    var id: Int
    var name: String
    var detailPicture: String
    var detailText: String
    var price: Double
    var article: String
    var brand: Brand?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "NAME"
        case detailPicture = "DETAIL_PICTURE"
        case detailText = "DETAIL_TEXT"
        case price = "PRICE"
        case article = "ARTICLE"
        case brand = "BRAND"
    }
}

struct Brand: Codable {
    var id: String
    var name: String
    var detailPicture: String
    var detailText: String
    var logo: String
    var note: String?
    var country: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "NAME"
        case detailPicture = "DETAIL_PICTURE"
        case detailText = "DETAIL_TEXT"
        case logo = "LOGO"
        case note = "NOTE"
        case country = "COUNTRY"
    }
}

struct ProductProperties: Codable {
    var article: ProductProperty
    var brandId: ProductProperty
    var isNew: ProductProperty
    var type: ProductProperty
    var sale: ProductProperty
    var volume: ProductProperty
    var sameProduct: ProductProperty
    var hit: ProductProperty
    
    enum CodingKeys: String, CodingKey {
        case article = "ARTICLE"
        case brandId = "BRAND_ID"
        case isNew = "IS_NEW"
        case type = "TYPE"
        case sale = "SALE"
        case volume = "VOLUE"
        case sameProduct = "SAME_PRODUCT"
        case hit = "HIT"
    }
}

struct ProductProperty: Codable {
    
    var id: Int
    var name: String
    var active: String
    var sort: Int
    var code: String
    var value: [String]
    var propertyType: String
    var multiple: String
    var xmlId: Int
    var withDescription: String
    var searchable: String
    var filterable: String
    var isRequired: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "NAME"
        case active = "ACTIVE"
        case sort = "SORT"
        case code = "CODE"
        case value = "VALUE"
        case propertyType = "PROPERTY_TYPE"
        case multiple = "MULTIPLE"
        case xmlId = "XML_ID"
        case withDescription = "WITH_DESCRIPTION"
        case searchable = "SEARCHABLE"
        case filterable = "FILTERABLE"
        case isRequired = "IS_REQUIRED"
    }
}
