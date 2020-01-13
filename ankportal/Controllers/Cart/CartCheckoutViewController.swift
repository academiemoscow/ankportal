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
    
    struct CheckoutRow: Codable {
        var id: Int?
        var quantity: Int64?
    }

    struct CheckoutMessage: Codable {
        var name: String?
        var email: String?
        var phone: String?
        var products: [CheckoutRow]?
    }

    struct CheckoutMessageProduct: Codable {
        var id: String?
        var qty: Int64?
        var price: Double?
    }
    
    struct CheckoutField {
        var cellId: String
        var cellTypeName: String
        var getValueFn: ((_ message: inout CheckoutMessage, _ value: String) -> ())?
    }
    
    private let cells = [
        CheckoutField(
            cellId: "nameFieldCell",
            cellTypeName: "ankportal.CartCheckNameFieldCell",
            getValueFn: { (message, value) in
                message.name = value
        }
        ),
        CheckoutField(
            cellId: "phoneFieldCell",
            cellTypeName: "ankportal.CartCheckPhoneFieldCell",
            getValueFn: { (message, value) in
                message.phone = value
        }
        ),
        CheckoutField(
            cellId: "emailFieldCell",
            cellTypeName: "ankportal.CartCheckEmailFieldCell",
            getValueFn: { (message, value) in
                message.email = value
            }
        ),
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
    
    func getJsonSerialized() -> String? {
        var message = CheckoutMessage()
        for (index, data) in cells.enumerated() {
            if let fn = data.getValueFn {
                if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CartCheckoutFieldTableViewCell {
                    if let text = cell.field.field.text {
                        fn(&message, text)
                    }
                }
            }
        }
        message.products = Cart.shared.productsInCart.map({ CheckoutRow(id: Int($0.id), quantity: $0.quantity) })
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(message) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func prepareRequest() -> URLRequest? {
        guard
            let url = URL(string: "https://ankportal.ru/rest/index2.php"),
            let json = getJsonSerialized()
        else {
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "action": "sendmail",
            "password": "123btot456",
            "template": "REST_PRODUCT_LIST",
            "json": json
        ]
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        return request
    }
    
    func presentCompleteAlert() {
        let alert = UIAlertController(title: "Заказ", message: "Спасибо за проявленный интерес к нашей продукции!\nВ ближайшей время с Вами свяжутся наши операторы для уточнения деталей оплаты и доставки", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Да", style: .default) { [weak self] (action) in
            Cart.shared.clear()
            self?.dismiss(animated: true)
        }
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func didConfirmSend(_ cell: CartCheckoutFieldTableViewCell) {
        let alert = UIAlertController(title: "Заказ", message: "Действительно хотите отправить заказ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Да", style: .default) { [weak self] (action) in
            guard
                let context = self,
                let request = context.prepareRequest()
            else {
                return
            }
            
            cell.setState(.waiting)
            
            let task = URLSession.shared.dataTask(with: request) { (d, r, e) in
                cell.setState(.complete)
                guard let data = d,
                    let response = r as? HTTPURLResponse,
                    e == nil
                else {
                    print("error", e ?? "Unknown error")
                    return
                }
                print(String(data: d!, encoding: .utf8), response.statusCode)
                DispatchQueue.main.async {
                    context.presentCompleteAlert()
                }
            }
            
            task.resume()
        }
        let cancel = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}
