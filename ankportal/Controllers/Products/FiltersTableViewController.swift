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
    private(set) var restFilters: [RESTFilter]
    private(set) var values: [RESTParameter] = []
    private(set) var cellTypeName: String
    private(set) var reuseIdentifier: String
    
    init(name: String, restFilters: [RESTFilter], cellTypeName: String, reuseIdentifier: String) {
        self.name = name
        self.restFilters = restFilters
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
    
    var onDoneCallback: (([RESTParameter]) -> ())?

    enum Sections: String, CaseIterable {
        case main = "Основные"
        case price = "Цена"
        case advanced = "Дополнительно"
    }
    
    lazy var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var data = [
        Sections.main.rawValue : [
            FilterItem(name: "Бренд", restFilters: [.brandId], cellTypeName: "ankportal.BrandSelectTableViewCell", reuseIdentifier: "brandFilterCell"),
            FilterItem(name: "Направление", restFilters: [.sectionId], cellTypeName: "ankportal.LineSelectTableViewCell", reuseIdentifier: "lineFilterCell")
        ],
        
        Sections.price.rawValue : [
            FilterItem(name: "От", restFilters: [.price, .priceLess, .priceMore, .priceNot], cellTypeName: "ankportal.PriceInputTableViewCell", reuseIdentifier: "priceFilterCell")
        ],
        
        Sections.advanced.rawValue : [
        ]
    ]
    
    private var dataRESTParameters: [RESTParameter] {
        get {
            var result: [RESTParameter] = []
            
            Sections.allCases.forEach { (sectionCase) in
                if let items = self.data[sectionCase.rawValue] {
                    items.forEach {
                        result += $0.values
                    }
                }
            }
            
            return result
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupTableView()
        registerCells()
    }
    
    fileprivate func setupController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submit))
        title = "Фильтры"
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
    
    @objc func submit() {
        navigationController?.popViewController(animated: true)
        onDoneCallback?(dataRESTParameters)
    }
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.ankPurple.withAlphaComponent(0.8)
        
        let label = UILabel()
        label.text = Sections.allCases[section].rawValue
        label.font = UIFont.preferredFont(forTextStyle: .callout)
//        label.textColor = .bla
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
    
    //Инициализация выбранных ранее фильтров
    func setup(restParametres: [RESTParameter]) {
        ANKPortalCatalogs.desellectAll()
        restParametres.forEach { (restParameter) in
            Sections.allCases.forEach({ (section) in
                self.data[section.rawValue]?.forEach({ (filterItem) in
                    let filtersRawValues = filterItem.restFilters.map({ return $0.rawValue })
                    if (filtersRawValues.contains(restParameter.toSingle().name)) {
                        switch filterItem.cellTypeName {
                        case "ankportal.BrandSelectTableViewCell":
                            setupRESTForBrand(filterItem: filterItem, restParametres: [restParameter])
                        case "ankportal.LineSelectTableViewCell":
                            setupRESTForLine(filterItem: filterItem, restParametres: [restParameter])
                        case "ankportal.PriceInputTableViewCell":
                            setupRESTForPrice(filterItem: filterItem, restParametres: [restParameter])
                        default:
                            print("Not found cell")
                        }
                    }
                })
            })
        }
    }
    
    private func setupRESTForBrand(filterItem: FilterItem, restParametres: [RESTParameter]) {
        setupREST(
            forFilterItem: filterItem,
            withCatalog: ANKPortalCatalogs.brands,
            withRESTParametres: restParametres
        )
    }
    
    private func setupRESTForLine(filterItem: FilterItem, restParametres: [RESTParameter]) {
        setupREST(
            forFilterItem: filterItem,
            withCatalog: ANKPortalCatalogs.sections,
            withRESTParametres: restParametres
        )
    }
    
    private func setupREST(forFilterItem filterItem: FilterItem, withCatalog catalog: ANKPortalCatalog, withRESTParametres restParametres: [RESTParameter]) {
        catalog.getAll {(items, error) in
            items.forEach({ (brand) in
                if let id = brand.id {
                    restParametres.forEach({
                        if $0.value == id {
                            brand.isSelected = true
                            let restANKParameter = RESTParameterANKPortalItem(name: $0.name, value: $0.value)
                            restANKParameter.description = brand.name!
                            restANKParameter.ankportalItem = brand
                            filterItem.add(values: [restANKParameter])
                        }
                    })
                }
            })
        }
    }
    
    private func setupRESTForPrice(filterItem: FilterItem, restParametres: [RESTParameter]) {
        filterItem.add(values: restParametres)
    }

}
