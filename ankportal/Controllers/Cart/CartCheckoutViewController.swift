//
//  CartCheckoutViewController.swift
//  ankportal
//
//  Created by Admin on 04/10/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class CartCheckoutViewController: UITableViewController {
    
    private let cellDict = [
        "nameFieldCell": CartCheckPhoneFieldCell.self,
        "emailFieldCell": CartCheckEmailFieldCell.self
    ]
    
    lazy var fields: CartCheckout = {
        let fields = CartCheckout()
        fields.backgroundColor = .white
        fields.alwaysBounceVertical = true
        fields.translatesAutoresizingMaskIntoConstraints = false
        return fields
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupTableView()
    }
    
    private func setupTableView() {
        for cellId in cellDict.keys {
            tableView.register(cellDict[cellId], forCellReuseIdentifier: cellId)
        }
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = Array(cellDict.keys)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! CartCheckoutFieldTableViewCell
        return cell
    }
}
