//
//  CartObserver.swift
//  ankportal
//
//  Created by Admin on 09/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

protocol CartObserver: NSObject {
    func cart(didAppend product: CartProduct, to cart: Cart)
    func cart(didRemove product: CartProduct, from cart: Cart)
    func cart(didUpdate cart: Cart)
}

extension CartObserver {
    func cart(didAppend product: CartProduct, to cart: Cart) {}
    func cart(didRemove product: CartProduct, from cart: Cart) {}
    func cart(didUpdate cart: Cart) {}
}
