//
//  BrandListViewController.swift
//  ankportal
//
//  Created by Admin on 03/06/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class BrandListTableViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    
    let brandCellId = "cellId"
    
    let ankportalREST = ANKRESTService(type: .brandList)
    
    var data: [BrandSelectable] = []
    var dataFiltered: [BrandSelectable] = []
    var dataSelected: [BrandSelectable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        fetchData()
        setupSearchViewController()
        setupTableView()
        setupController()
    }
    
    func setupController() {
        navigationController?.navigationBar.shadowImage = UIImage()
        title = "Список брендов"
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    func setupSearchViewController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.backgroundColor = UIColor(r: 161, g: 142, b: 175)
        searchController.searchBar.placeholder = "Поиск бренда"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.sizeToFit()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func fetchData() {
        ankportalREST.execute {[weak self] (data, response, error) in
            if (error != nil) {
                print(error as Any)
                return
            }
            if let data = try? JSONDecoder().decode([BrandSelectable].self, from: data!) {
                self?.data = data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            
        }
    }
    
    func registerCells() {
        tableView.register(BrandTableViewCell.self, forCellReuseIdentifier: brandCellId)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dataSelected.count
        case 1:
            return searchController.isActive ? dataFiltered.count : data.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor(r: 157, g: 129, b: 186)
        label.textColor = UIColor.white
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = getTitlle(forSection: section)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSelected.count > 0 ? 50 : 0
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: brandCellId, for: indexPath) as! BrandTableViewCell
        let brand = getBrand(forIndexPath: indexPath)
        cell.configure(forBrand: brand)
        cell.delegate = self
        return cell
    }
    
    private func getTitlle(forSection section: Int) -> String {
        switch section {
        case 0:
            return "Выбранные"
        case 1:
            return searchController.isActive ? "Результаты поиска" : "Список"
        default:
            return ""
        }
    }
    
    private func getBrand(forIndexPath indexPath: IndexPath) -> BrandSelectable {
        switch indexPath.section {
        case 0:
            return dataSelected[indexPath.row]
        case 1:
            return data[indexPath.row]
        default:
            return data[indexPath.row]
        }
    }
}

extension BrandListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
}

extension BrandListTableViewController: BrandTableViewCellDelegate {
    func didSelect(brand: BrandSelectable) {
        brand.isSelected = !brand.isSelected
        if (brand.isSelected) {
            select(brand: brand)
        } else {
            deselect(brand: brand)
        }
    }
    
    func select(brand: BrandSelectable) {
        guard let index = data.firstIndex(where: { $0.id == brand.id }) else {
            return
        }
        
        let oldIndexPath = IndexPath(row: index, section: 1)
        
        let newIndex = dataSelected.count
        let newIndexPath = IndexPath(row: newIndex, section: 0)
        
        dataSelected.append(data.remove(at: index))
        
        tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        tableView.reloadRows(at: [newIndexPath], with: .fade)
    }
    
    func deselect(brand: BrandSelectable) {
        guard let index = dataSelected.firstIndex(where: { $0.id == brand.id }) else {
            return
        }
        
        let oldIndexPath = IndexPath(row: index, section: 0)
        let newIndexPath = IndexPath(row: 0, section: 1)
        
        data.insert(dataSelected.remove(at: index), at: 0)
        
        if (searchController.isActive) {
            tableView.deleteRows(at: [oldIndexPath], with: .fade)
        } else {
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            tableView.reloadRows(at: [newIndexPath], with: .fade)
        }
    }
    
}
