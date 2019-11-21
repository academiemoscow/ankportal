//
//  CartCheckoutViewController.swift
//  ankportal
//
//  Created by Admin on 04/10/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class CartCheckoutViewController: UITableViewController {
    
    private var completed: Int = 0
    
    struct CheckoutField {
        var cellId: String
        var cellTypeName: String
    }
    
    private let cells = [
        CheckoutField(cellId: "nameFieldCell", cellTypeName: "ankportal.CartCheckNameFieldCell"),
        CheckoutField(cellId: "phoneFieldCell", cellTypeName: "ankportal.CartCheckPhoneFieldCell"),
        CheckoutField(cellId: "emailFieldCell", cellTypeName: "ankportal.CartCheckEmailFieldCell"),
        CheckoutField(cellId: "buttonCell", cellTypeName: "ankportal.CartCheckoutButton")
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
        setupNavController()
    }
    
    private func setupNavController() {
        title = "Оформление"
    }
    
    private func setupTableView() {
        cells.forEach {
            tableView.register(NSClassFromString($0.cellTypeName) as! UITableViewCell.Type, forCellReuseIdentifier: $0.cellId)
        }
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == cells.count {
            let descriptionCell = UITableViewCell(style: .default, reuseIdentifier: "descriptionCellId")
            descriptionCell.textLabel?.font = UIFont.defaultFont(forTextStyle: .headline)
            descriptionCell.textLabel?.textColor = .gray
            descriptionCell.textLabel?.text = "При отправке заказа, наши операторы получат информацию о ваших пожеланиях и свяжутся с Вами для уточнения деталей заказа"
            descriptionCell.textLabel?.textAlignment = .center
            descriptionCell.textLabel?.numberOfLines = 0
            return descriptionCell
        }
        let cellId = cells[indexPath.row].cellId
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! CartCheckoutFieldTableViewCell
        cell.delegate = self
        return cell
    }
}

extension CartCheckoutViewController: CartCheckoutCellDelegate {
    func didChangeState(_ cell: CartCheckoutFieldTableViewCell) {
    }
    
    func didChangeFieldState(_ field: CartCheckOutField) {
        if field.state == .complete {
            completed += 1
        } else {
            completed -= 1
        }

        if let cell = tableView.cellForRow(at: IndexPath(row: cells.count - 1, section: 0)) as? CartCheckoutFieldTableViewCell {
            if completed == cells.count - 1 {
                cell.setState(.complete)
            } else {
                cell.setState(.incomplete)
            }
        }
    }
    
    func didConfirmSend(_ cell: CartCheckoutFieldTableViewCell) {
        let alert = UIAlertController(title: "Заказ", message: "Действительно хотите отправить заказ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Да", style: .default) { [weak self] (action) in
            guard let context = self else {
                return
            }
            Cart.shared.clear()
            context.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}
