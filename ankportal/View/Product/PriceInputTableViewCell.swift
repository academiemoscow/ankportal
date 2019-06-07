//
//  TableViewCell.swift
//  ankportal
//
//  Created by Admin on 06/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class PriceInputTableViewCell: ClickableFilterTableViewCell, UITextFieldDelegate {
    
    private let currencyFormatter = CurrencyFormatter(maximumFractionDigits: 2)
    
    override class var rowHeight: CGFloat {
        return 100
    }
    
    lazy var priceTextFieldMin: TextField = {
        let textField = TextField()
        textField.placeholder = "От"
        textField.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20)
        textField.keyboardType = UIKeyboardType.decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = NSTextAlignment.center
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.delegate = self
        textField.inputAccessoryView = submitButton
        return textField
    }()
    
    lazy var priceTextFieldMax: TextField = {
        let textField = TextField()
        textField.placeholder = "До"
        textField.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20)
        textField.keyboardType = UIKeyboardType.decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = NSTextAlignment.center
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.delegate = self
        textField.inputAccessoryView = submitButton
        return textField
    }()
    
    lazy var imageSeparatorView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "right")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = UIColor.black.withAlphaComponent(0.2)
        imageView.clipsToBounds = true
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: .zero, y: .zero, width: .zero, height: 50))
        button.backgroundColor = UIColor.ankPurple
        button.addTarget(self, action: #selector(submitHandler), for: .touchUpInside)
        button.setTitle("Готово", for: .normal)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceTextFieldMin, imageSeparatorView, priceTextFieldMax])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fillEqually
        return stackView
    }()
    
    @objc private func submitHandler() {
        endEditing(true)
        filterItem?.removeAllValues()
        setPriceMin()
        setPriceMax()
        if let count = filterItem?.values.count, count > 0 {
            filterItem?.add(values: [RESTParameter(filter: .priceNot, value: "0")])
        }
    }
    
    private func setPriceMin() {
        guard let dValue = getValue(from: priceTextFieldMin.text), dValue > 0 else {
            return
        }
        filterItem?.add(values: [RESTParameter(filter: .priceMore, value: "\(dValue)")])
    }
    
    private func setPriceMax() {
        guard let dValue = getValue(from: priceTextFieldMax.text), dValue > 0 else {
            return
        }
        filterItem?.add(values: [RESTParameter(filter: .priceLess, value:  "\(dValue)")])
    }
    
    private func getValue(from: String?) -> Double? {
        guard let value = from else {
            return nil
        }
        let valueWithComma = value.replacingOccurrences(of: "[.,]", with: ",", options: .regularExpression)
        let valueWithDot = value.replacingOccurrences(of: "[.,]", with: ".", options: .regularExpression)
        
        if let dValue = Double(valueWithDot.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) {
            return dValue
        }
        
        return Double(valueWithComma.replacingOccurrences(of: "[^0-9,]", with: "", options: .regularExpression))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didSelect(_ target: FiltersTableViewController, cellRowAtIndexPath indexPath: IndexPath) {
    }
    
    override func configureCell(forModel model: FilterItem) {
        super.configureCell(forModel: model)
        setupValuesFrom(filterItem: filterItem)
    }
    
    private func setupValuesFrom(filterItem: FilterItem?) {
        filterItem?.values.forEach({ (restParameter) in
            guard let restFilter = RESTFilter(rawValue: restParameter.name) else {
                return
            }
            var textField: UITextField!
            
            switch restFilter {
            case .priceLess:
                textField = priceTextFieldMax
            case .priceMore:
                textField = priceTextFieldMin
            default:
                return
            }
            
            textField.text = restParameter.value
            guard let text = textField.text else {
                return
            }
            let _ = self.textField(textField, shouldChangeCharactersIn: NSRange(location: 0, length: text.count - 1), replacementString: text)
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        guard !newText.isEmpty, textField.keyboardType == .decimalPad else { return true }
        
        let separator = self.currencyFormatter.decimalSeparator!
        var components = newText.components(separatedBy: separator)
        if components.count <= 1 {
            components = newText.components(separatedBy: ".")
        }
        
        if components.count > 1 && components[1].count > self.currencyFormatter.maximumFractionDigits {
            return false
        }
        
        guard let cleaned = components.first?.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) else { return true }
        
        var doubleValue: Double?
        if (components.count > 1) {
            doubleValue = Double(cleaned + separator + components[1])
            if doubleValue == nil {
                doubleValue = Double(cleaned + "." + components[1])
            }
        }
        
        if let value = doubleValue ?? Double(cleaned) {
            var formatted = self.currencyFormatter.beautify(value)
            if (components.count > 1 && (components[1].isEmpty || components[1].range(of: "^0*$", options: .regularExpression) != nil)) {
                formatted += separator + components[1]
            }
            textField.text = formatted
        }
        
        return false
    }
}
