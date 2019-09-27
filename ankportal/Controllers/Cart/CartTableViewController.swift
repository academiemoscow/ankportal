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
    
    private let productsCatalog = ProductsCatalog()
    
    private var data = [(Product, Int64)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setup() {
        registerCells()
        setupNavController()
        setupTableView()
    }
    
    func setupNavController() {
        title = "Корзина"
    }
    
    func registerCells() {
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CartTableViewCell
        
        cell.configure(forData: data[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = data.remove(at: indexPath.row).0
            Cart.shared.removeProduct(withID: String(product.id))
            tableView.deleteRows(at: [indexPath], with: .fade)
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
