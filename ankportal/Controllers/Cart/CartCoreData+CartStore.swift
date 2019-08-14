//
//  CartCoreData.swift
//  ankportal
//
//  Created by Admin on 09/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CartCoreData: CartStore {
    
    let container: NSPersistentContainer! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func getData() -> [CartProduct] {
        let storeData = getDataFromStore()
        return storeData.map({ return CartProduct(id: $0.productID!, quantity: $0.quantity) })
    }
    
    func updateData(_ data: [CartProduct]) {
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
        
        let dataToDelete = storeData.filter({ (storeItem) in !data.contains(where: { storeItem.productID! == $0.id }) })
        dataToDelete.forEach({ context.delete($0) })
        
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
