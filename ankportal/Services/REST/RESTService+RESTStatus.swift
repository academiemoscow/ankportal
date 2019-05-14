//
//  RESTService.swift
//  ankportal
//
//  Created by Admin on 26/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

enum RESTStatus {
    case error
    case complete
    case new
}

protocol RESTService {
    func getRESTStatus() -> RESTStatus
    func execute(callback: @escaping (Data?, URLResponse?, Error?) -> Void)
}
