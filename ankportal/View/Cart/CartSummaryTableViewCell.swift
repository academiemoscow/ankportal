//
//  CartSummaryTableViewCell.swift
//  ankportal
//
//  Created by Admin on 21/11/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class CartSummaryTableViewCell: UITableViewCell {

    private var data = [(Product, Int64)]()
    private let productsCatalog = ProductsCatalog()
    
    init(reuseIdentifier id: String) {
        super.init(style: .subtitle, reuseIdentifier: id)
        Cart.shared.add(self)
        fetchData()
    }
    
    deinit {
        Cart.shared.remove(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchData() {
        data = []
        let dispatchGroup = DispatchGroup()
        Cart.shared.productsInCart.forEach { (product) in
            guard let id = Int(product.id)
            else {
                return
            }
            let qty = product.quantity
            dispatchGroup.enter()
            self.productsCatalog.getBy(id: id) {[weak self] (product) in
                if let product = product {
                    self?.data.append((product, qty))
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: DispatchQueue(label: "fetchProducts")) {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(_ data: [(Product, Int64)]) {
        self.data = data
    }
    
    func getSummary() -> Double {
        return data.reduce(0) { (res, productTupple) -> Double in
            let (product, qty) = productTupple
            if (product.price < 50) {
                return res
            }
            return res + product.price * Double(qty)
        }
    }
    
    func updateView() {
        let formatter = CurrencyFormatter()
        formatter.minimumFractionDigits = 2
        textLabel?.text = "Итого: \(formatter.beautify(getSummary())) рублей"
        
        textLabel?.font = UIFont.defaultFontBold(forTextStyle: .title2)
        detailTextLabel?.font = UIFont.defaultFont(forTextStyle: .headline)
        detailTextLabel?.textColor = .gray
        detailTextLabel?.text = "В том числе НДС 20%"
    }
    
}

extension CartSummaryTableViewCell: CartObserver {
    
    func cart(didUpdate cart: Cart) {
        fetchData()
    }
    
    func cart(didRemove product: CartProduct, from cart: Cart) {
        fetchData()
    }
}
