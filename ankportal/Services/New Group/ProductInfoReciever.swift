//
//  ProductInfoReciever.swift
//  ankportal
//
//  Created by Admin on 04/07/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

typealias RequestProductByIdCallback = (Product?) -> ()

protocol ProductInfoReciever {
    func fetchProduct(by barcode: String, _ callback: RequestProductByIdCallback)
}

class XMLParserTagValue: XMLParser, XMLParserDelegate {
    
    private var searchTagName: String
    private var currentElement = ""
    
    private(set) var value = ""
    
    init(data: Data, tagName: String) {
        searchTagName = tagName
        super.init(data: data)
        delegate = self
    }
    
    //MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == searchTagName {
            value += string
        }
    }
    
}

class SOAPProductReciever: ProductInfoReciever {
    
    static var WebserviceURLString: String {
        get {
            return "http://80.79.114.230/ckat2010/scanning.nsf/getProductInfo?OpenWebService"
        }
    }
    
    private lazy var urlRequest: URLRequest? = {
        if let serviceURL = URL(string: SOAPProductReciever.WebserviceURLString) {
            var request = URLRequest(url: serviceURL)
            request.httpMethod = "POST"
            return request
        }
        
        return nil
    }()
    
    public func fetchProduct(by barcode: String, _ callback: (Product?) -> ()) {
        guard var request = urlRequest else {
            return
        }
        request.httpBody = getHTTPBody(withParameter: barcode).data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (d, r, e) in
            guard let data = d else {
                return
            }
            let xmlParser = XMLParserTagValue(data: data, tagName: "BYBARCODEReturn")
            if xmlParser.parse() {
                print(xmlParser.value)
            }
        }.resume()
    }
    
    private func getHTTPBody(withParameter barcode: String) -> String {
        return "<?xml version='1.0' encoding='utf-8'?><S:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:S='http://schemas.xmlsoap.org/soap/envelope/'><S:Body><ns2:BYBARCODE xmlns:ns2='urn:DefaultNamespace'><BARCODE xsi:type='xsd:string'>\(barcode)</BARCODE></ns2:BYBARCODE></S:Body></S:Envelope>"
    }

}
