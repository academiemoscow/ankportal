//
//  ProductsTableViewController.swift
//  ankportal
//
//  Created by Admin on 23/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController {
    
    private let defaultCellId = "defaultProductCell"
    private let placeholderCellId = "placeholderProductCell"
    private let notFoundCellId = "notFoundProductCell"
    private let navigationBarColor = UIColor(r: 159, g: 131, b: 174)
    
    private let ankportalREST = ANKRESTService(type: .productList)
    private var paginationRESTParametres: [RESTParameter] = [
        RESTParameter(filter: .pageSize, value: "50"),
        RESTParameter(filter: .pageNumber, value: "1")
    ]
    private var restParametres: [RESTParameter] {
        get {
            return optionalRESTFilters + paginationRESTParametres
        }
    }
    
    var optionalRESTFilters: [RESTParameter] = []
    var optionalRESTFiltersCount: Int {
        get {
            return optionalRESTFilters.map({ (restParameter) -> String in
                return restParameter.name.replacingOccurrences(of: "[<>!]", with: "", options: .regularExpression)
            }).uniqueElementsCount()
        }
    }
    
    private lazy var tableHeaderView: ProductListToolbar = {
        let toolbar = ProductListToolbar()
        toolbar.delegate = self
        return toolbar
    }()
    
    private lazy var refreshController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableViewHandler), for: .valueChanged)
        return refreshControl
    }()
    
    var data = [ProductPreview]()
    var isLoading = true {
        didSet {
            guard oldValue != self.isLoading else {
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        setupTableView()
        setupNavigationController()
        fetchData()
        
    }
    
    fileprivate func setupNavigationController() {
        navigationItem.title = "Каталог"
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = navigationBarColor
        navigationController?.navigationBar.barTintColor = navigationBarColor
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let attributesForLargeTitle: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = attributesForLargeTitle
        
        let attributesForSmallTitle: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = attributesForSmallTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(pushScannerVC))
    }
    
    @objc fileprivate func pushScannerVC() {
        let vc = ScannerViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc fileprivate func refreshTableViewHandler() {
        fetchData()
    }
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.tableHeaderView = tableHeaderView
        tableView.refreshControl = refreshController
        
    }
    
    fileprivate func registerCells() {
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: defaultCellId)
        tableView.register(PlaceholderTableViewCell.self, forCellReuseIdentifier: placeholderCellId)
        tableView.register(NotFoundTableViewCell.self, forCellReuseIdentifier: notFoundCellId)
    }
    
    func fetchData() {
        isLoading = true
        tableHeaderView.setBadge(optionalRESTFiltersCount)
        ankportalREST.execute(withParametres: restParametres) { [weak self] (data, respone, error) in
            DispatchQueue.main.async {
                self?.refreshController.endRefreshing()
            }
            if ( error != nil ) {
                print(error!)
                return
            }
            self?.data.removeAll()
            if let data = try? JSONDecoder().decode([ProductPreview].self, from: data!) {
                self?.data = data
            }
            self?.isLoading = false
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( isLoading ) {
            return data.count == 0 ? 2 : data.count
        } else {
            return data.count == 0 ? 1 : data.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = prepareCell(forIndexPath: indexPath)
        return cell
    }
    
    func prepareCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        if ( isLoading ) {
            let cell = tableView.dequeueReusableCell(withIdentifier: placeholderCellId, for: indexPath) as! PlaceholderTableViewCell
            return cell
        }
        guard data.count > 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: notFoundCellId, for: indexPath) as! NotFoundTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellId, for: indexPath) as! ProductTableViewCell
        cell.configure(forModel: data[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
}

extension ProductsTableViewController: ProductListToolbarDelegate {
    func didTapButton(_ sender: ProductListToolbar.ProductListToolbarItemType) {
        switch sender {
        case .sorting:
            sortingButtonHandler()
        case .filter:
            filterButtonHandler()
        }
    }
    
    func sortingButtonHandler() {
        let sortingVC = UIPickerViewController()
        sortingVC.modalPresentationStyle = .overFullScreen
        present(sortingVC, animated: true, completion: nil)
    }
    
    func filterButtonHandler() {
        let filterVC = FiltersTableViewController()
        filterVC.setup(restParametres: optionalRESTFilters)
        filterVC.onDoneCallback = { [weak self] (restParametres) in
            if let optionalRESTFilters = self?.optionalRESTFilters, restParametres == optionalRESTFilters {
                return
            }
            self?.optionalRESTFilters.removeAll()
            self?.optionalRESTFilters += restParametres
            self?.fetchData()
        }
        navigationController?.pushViewController(filterVC, animated: true)
    }
}
