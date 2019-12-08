//
//  Cart.swift
//  ankportal
//
//  Created by Admin on 09/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation

class WeakCartObserver: NSObject, CartObserver {
    weak var observer : CartObserver?
  
    init (observer: CartObserver) {
        self.observer = observer
    }
    
    func cart(didRemove product: CartProduct, from cart: Cart) {
        observer?.cart(didRemove: product, from: cart)
    }
    
    func cart(didUpdate cart: Cart) {
        observer?.cart(didUpdate: cart)
    }
    
    func cart(didAppend product: CartProduct, to cart: Cart) {
        observer?.cart(didAppend: product, to: cart)
    }
}

class Cart {
    
    private let cartStore: CartStore = CartCoreData()
    private var observers: [WeakCartObserver] = []
    
    static let shared = Cart()
    
    var productsInCart: [CartProduct] = [] {
        didSet {
            didUpdate()
        }
    }
    
    var ids: [String] {
        get {
            return productsInCart.map({ $0.id })
        }
    }
    
    var count: Int64 {
        get {
            return productsInCart.reduce(0, { $0 + $1.quantity })
        }
    }
    
    private init() {
        initializeFromStore()
    }
    
    private func initializeFromStore() {
        productsInCart = cartStore.getData()
    }
    
    func addProduct(withID id: String) {
        if !increment(withID: id) {
            productsInCart.append(CartProduct(id: id, quantity: 1))
            cartStore.updateData(productsInCart)
            didAppend(productsInCart.last!)
        }
    }
    
    func set(Qty qty: Int64, forID id: String) -> Bool {
        guard qty > 0 else {
            return false
        }
        
        if let index = getIndex(of: id) {
            productsInCart[index].quantity = qty
            cartStore.updateData(productsInCart)
            return true
        }
        
        return false
    }
    
    func increment(withID id: String) -> Bool {
        if let index = getIndex(of: id) {
            productsInCart[index].quantity = productsInCart[index].quantity + 1
            cartStore.updateData(productsInCart)
            return true
        }
        
        return false
    }
    
    func decrement(withID id: String) -> Bool {
        if let index = getIndex(of: id),
        productsInCart[index].quantity > 1 {
            productsInCart[index].quantity = productsInCart[index].quantity - 1
            cartStore.updateData(productsInCart)
            return true
        }
        
        return false
    }
    
    func removeProduct(withID id: String) {
        guard let index = getIndex(of: id) else {
            return
        }
        let deletingProduct = productsInCart[index]
        productsInCart = productsInCart.filter({ $0.id != id })
        cartStore.updateData(productsInCart)
        didRemove(deletingProduct)
    }
    
    func inCart(productID id: String) -> Bool {
        guard let _ = getIndex(of: id) else {
            return false
        }
        return true
    }
    
    func clear() {
        productsInCart = []
        cartStore.updateData(productsInCart)
    }
    
    func quantity(forId id: String) -> Int64 {
        return productsInCart.filter({ $0.id == id }).first?.quantity ?? 0
    }
    
    private func getIndex(of id: String) -> Int? {
        return productsInCart.firstIndex(where: { $0.id == id })
    }
    
    private func didAppend(_ product: CartProduct) {
        observers.forEach({ $0.cart(didAppend: product, to: self) })
    }
    
    private func didRemove(_ product: CartProduct) {
        observers.forEach({ $0.cart(didRemove: product, from: self) })
    }
    
    private func didUpdate() {
        observers.forEach({ $0.cart(didUpdate: self) })
    }
}


// MARK: - Observer functionality
extension Cart {
    
    func clearObservers() {
        observers = observers.filter({ $0.observer !== nil })
    }
    
    func add(_ observer: CartObserver) {
        clearObservers()
        if observers.filter({ $0.observer! == observer }).count == 0 {
            observers.append(WeakCartObserver(observer: observer))
        }
    }
    
    func remove(_ observer: CartObserver) {
        clearObservers()
        observers = observers.filter { $0.observer! !== observer }
    }
    
}
