//
//  CartStore.swift
//  ankportal
//
//  Created by Admin on 09/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

protocol CartStore {
    func getData() -> [CartProduct]
    func updateData(_ data: [CartProduct])
}
