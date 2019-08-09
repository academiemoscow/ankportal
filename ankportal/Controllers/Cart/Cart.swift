//
//  Cart.swift
//  ankportal
//
//  Created by Admin on 09/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct ProductInCart {
    var id: String
    var quantity: Int64
}

protocol CartStore {
    func getData() -> [ProductInCart]
    func updateData(_ data: [ProductInCart])
}

class CartCoreData: CartStore {

    var container: NSPersistentContainer! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func getData() -> [ProductInCart] {
        let storeData = getDataFromStore()
        return storeData.map({ return ProductInCart(id: $0.productID!, quantity: $0.quantity) })
    }
    
    
    func updateData(_ data: [ProductInCart]) {
        let storeData = getDataFromStore()
        let context = container.viewContext
        data.forEach { (product) in
            if let productInStore = storeData.first(where: { $0.productID! == product.id }) {
                productInStore.quantity = product.quantity
                return
            }
            let newProductInStore = CartData(context: context)
            newProductInStore.productID = product.id
            newProductInStore.quantity = product.quantity
        }
        saveContext()
    }
    
    private func getDataFromStore() -> [CartData] {
        let request: NSFetchRequest = CartData.fetchRequest()
        let context = container.viewContext
        
        if let result = try? context.fetch(request) {
            return result
        }
        
        return []
    }
    
    private func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed save")
            }
        }
    }
}

class Cart {
    
    static let shared = Cart()
    
    var productsInCart: [ProductInCart] = []
    
    private let cartStore: CartStore = CartCoreData()
    
    private init() {
        initializeFromStore()
    }
    
    private func initializeFromStore() {
        productsInCart = cartStore.getData()
    }
    
    func addProduct(withID id: String) {
        if var product = productsInCart.first(where: { $0.id == id }) {
            product.quantity = product.quantity + 1
            return
        }
        productsInCart.append(ProductInCart(id: id, quantity: 1))
        cartStore.updateData(productsInCart)
    }
    
    func inCart(productID id: String) -> Bool {
        if let _ = productsInCart.first(where: { $0.id == id }) {
            return true
        }
        return false
    }
}
