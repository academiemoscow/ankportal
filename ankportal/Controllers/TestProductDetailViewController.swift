//
//  TestProductDetailViewController.swift
//  ankportal
//
//  Created by Admin on 06/08/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class TestProductDetailViewController: UIViewController {
    
    let tableView = ParalaxHeaderTableView(headerView: UIImageView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.headerHeight = 350
    }

}
