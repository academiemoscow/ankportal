//
//  CartTableViewController.swift
//  ankportal
//
//  Created by Admin on 26/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class CartTableViewController: UITableViewController {

    private let cellId = "productInCartCell"
    private let summaryCellId = "summaryCartCell"
    
    private let productsCatalog = ProductsCatalog()
    
    private var data = [(Product, Int64)]() {
        didSet {
            DispatchQueue.main.async {
                self.updateBackgroundView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
        Cart.shared.add(self)
    }
    
    func setup() {
        registerCells()
        setupNavController()
        setupTableView()
    }
    
    func setupNavController() {
        title = "Корзина"
        
        if Cart.shared.count > 0 {
            let barButton = UIBarButtonItem()
            barButton.title = "Оформить"
            barButton.target = self
            barButton.action = #selector(showCheckout)
            navigationItem.rightBarButtonItem = barButton
        }
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.title = "Свернуть"
        leftBarButton.target = self
        leftBarButton.action = #selector(closeView)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showCheckout() {
        let vc = CartCheckoutViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func registerCells() {
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: summaryCellId)
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        updateBackgroundView()
    }
    
    func updateBackgroundView() {
        if Cart.shared.count == 0 {
            tableView.backgroundView = CartBgView()
        } else {
            tableView.backgroundView = nil
        }
    }

    func fetchData() {
        let dispatchGroup = DispatchGroup()
        Cart.shared.productsInCart.forEach { (product) in
            guard let id = Int(product.id)
            else {
                return
            }
            let qty = product.quantity
            dispatchGroup.enter()
            self.productsCatalog.getBy(id: id) { (product) in
                if let product = product {
                    self.data.append((product, qty))
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: DispatchQueue(label: "fetchProducts")) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count == 0 ? 0 : data.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == data.count) {
            let summaryCell = CartSummaryTableViewCell(reuseIdentifier: summaryCellId)
            return summaryCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CartTableViewCell
        
        cell.configure(forData: data[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (product, _) = data[indexPath.row]
        print(product.id)
        
        let productInfoViewController = ProductInfoTableViewController()
        productInfoViewController.productId = String(Int(product.id))
            navigationController?.pushViewController(productInfoViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == data.count) {
            return 100
        }
        return 200
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.row == data.count {
            return false
        }
        return true
    }

    func removeProduct(at indexPath: IndexPath) {
        let product = data.remove(at: indexPath.row).0
        
        var indexPaths = [indexPath]
        if data.count == 0 {
            let summaryIndexPath = IndexPath(row: 1, section: 0)
            indexPaths.append(summaryIndexPath)
        }
        
        Cart.shared.removeProduct(withID: String(product.id))
        tableView.deleteRows(at: indexPaths, with: .fade)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeProduct(at: indexPath)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CartTableViewController: CartObserver {
    func cart(didRemove product: CartProduct, from cart: Cart) {
        if let index = data.firstIndex(where: { String($0.0.id) == product.id }) {
            removeProduct(at: IndexPath(row: index, section: 0))
        }
    }
}
