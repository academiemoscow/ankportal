//
//  FiltersTableViewController.swift
//  ankportal
//
//  Created by Admin on 22/05/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class FilterItem {
    
    private(set) var name: String
    private(set) var restFilter: RESTFilter
    private(set) var values: [RESTParameter] = []
    private(set) var cellTypeName: String
    private(set) var reuseIdentifier: String
    
    init(name: String, restFilter: RESTFilter, cellTypeName: String, reuseIdentifier: String) {
        self.name = name
        self.restFilter = restFilter
        self.cellTypeName = cellTypeName
        self.reuseIdentifier = reuseIdentifier
    }
    
    public func add(values: [RESTParameter]) {
        self.values += values
    }
    
    public func removeAllValues() {
        values.removeAll()
    }
    
    public func getDescription() -> String {
        var descriptions: [String] = []
        values.forEach { (restParameter) in
            guard restParameter.description.count > 0 else {
                return
            }
            descriptions.append("\(restParameter)")
        }
        return descriptions.joined(separator: ", ")
    }
}

class FiltersTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum Sections: String, CaseIterable {
        case main = "Основные"
        case price = "Цена"
        case advanced = "Дополнительно"
    }
    
    lazy var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var data = [
        Sections.main.rawValue : [
            FilterItem(name: "Бренд", restFilter: .brandId, cellTypeName: "ankportal.BrandSelectTableViewCell", reuseIdentifier: "brandFilterCell"),
            FilterItem(name: "Направление", restFilter: .brandId, cellTypeName: "ankportal.LineSelectTableViewCell", reuseIdentifier: "lineFilterCell")
        ],
        
        Sections.price.rawValue : [
            FilterItem(name: "От", restFilter: .brandId, cellTypeName: "ankportal.PriceInputTableViewCell", reuseIdentifier: "priceFilterCell")
        ],
        
        Sections.advanced.rawValue : [
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerCells()
    }
    
    fileprivate func registerCells() {
        Sections.allCases.forEach { (sectionCase) in
            if let items = self.data[sectionCase.rawValue] {
                items.forEach {
                    self.tableView.register(NSClassFromString($0.cellTypeName) as! UITableViewCell.Type, forCellReuseIdentifier: $0.reuseIdentifier)
                }
            }
        }
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.separatorStyle = .none
    }
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.ankPurple.withAlphaComponent(0.8)
        
        let label = UILabel()
        label.text = Sections.allCases[section].rawValue
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .white
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return numberOfRowsIn(section: section) == 0 ? 0 : 50
    }
    
    private func numberOfRowsIn(section: Int) -> Int {
        return data[Sections.allCases[section].rawValue]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = getData(forRowAt: indexPath)
        let classType = NSClassFromString(data.cellTypeName) as! ClickableFilterTableViewCell.Type
        return classType.rowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filterItem = getData(forRowAt: indexPath)
        guard let cell = getCell(
            tableView,
            withIdentifier: filterItem.reuseIdentifier,
            forRowAt: indexPath
        ) else {
            return UITableViewCell()
        }
        cell.configureCell(forModel: filterItem)
        return cell
    }
    
    private func getCell(_ tableView: UITableView, withIdentifier identifier: String, forRowAt indexPath: IndexPath) -> ClickableFilterTableViewCell? {
        return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ClickableFilterTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let index = tableView.indexPathsForVisibleRows?.index(of: indexPath) {
            if let cell = tableView.visibleCells[index] as? ClickableFilterTableViewCell {
                cell.didSelect(self, cellRowAtIndexPath: indexPath)
            }
        }
    }
    
    func getData(forRowAt indexPath: IndexPath) -> FilterItem {
        let sectionCase = Sections.allCases[indexPath.section]
        return data[sectionCase.rawValue]![indexPath.row]
    }

}
