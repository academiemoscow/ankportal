//
//  CartCheckoutViewController.swift
//  ankportal
//
//  Created by Admin on 04/10/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class CartCheckoutViewController: UITableViewController {
    
    lazy var fields: CartCheckout = {
        let fields = CartCheckout()
        fields.backgroundColor = .white
        fields.alwaysBounceVertical = true
        fields.translatesAutoresizingMaskIntoConstraints = false
        return fields
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
