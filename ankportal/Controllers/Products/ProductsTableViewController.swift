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
    private var restParametres: [RESTParameter] {
        get {
            return optionalRESTFilters + paginationRESTParametres
        }
    }
    
    private var paginationRESTParametres: [RESTParameter] = [
        RESTParameter(filter: .pageSize, value: "50"),
        RESTParameter(filter: .pageNumber, value: "1")
    ]
    
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
    
    private var headerHeight: CGFloat = 30
    
    private lazy var refreshController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableViewHandler), for: .valueChanged)
        return refreshControl
    }()
    
    var data = [ProductPreview]()
    var dataLoaded = [ProductPreview]()
    var dataSearch = [ProductPreview]()
    
    lazy var productFinder: ProductFinder = {
        let finder = ProductFinder()
        finder.delegate = self
        return finder
    }()
    
    var isLoading = true {
        didSet {
            guard oldValue != self.isLoading else {
                return
            }
            DispatchQueue.main.async {
                self.data = self.searchController.isActive ? self.dataSearch : self.dataLoaded
                self.tableView.reloadData()
            }
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var searchTextField: UITextField? = { [weak self] in
        var textField: UITextField?
        
        self?.searchController.searchBar.subviews.forEach({ (view) in
            view.subviews.forEach({ (view) in
                if let view = view as? UITextField {
                    textField = view
                }
            })
        })
        
        return textField
    }()
    
    var logoIsHidden: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset.top = 12
        
        firstPageController = self
        
        setupSearchViewController()
        registerCells()
        setupTableView()
        setupNavigationController()
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstPageController = self
        setupNavigationController()
        setupSearchViewController()
    }
    
    override func viewDidLayoutSubviews() {
//        animateVisibleCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func animateVisibleCells() {
        let tableViewHeightHalf = getTableViewCenterY()
        tableView.visibleCells.forEach({ (cell) in
            if let cell = cell as? ProductTableViewCell {
                let yOffsetless = cell.center.y - tableView.contentOffset.y
                let distantFromCenter = abs(tableViewHeightHalf - yOffsetless)
                cell.scalePropertyAnimation.fractionComplete = distantFromCenter / tableViewHeightHalf
            }
        })
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let tableViewHeightHalf = getTableViewCenterY()
        let searchPoint = CGPoint(x: targetContentOffset.pointee.x, y: targetContentOffset.pointee.y + scrollView.frame.height / 2)
        let rect = getNearestCellRect(forPoint: searchPoint)
        let centerY = rect.origin.y + rect.height / 2
        let calcContentOffsetY = (centerY - tableViewHeightHalf)
        targetContentOffset.pointee = CGPoint(x: targetContentOffset.pointee.x, y: calcContentOffsetY)
    }
    
    private func getNearestCellRect(forPoint point: CGPoint) -> CGRect {
        return tableView.rectForRow(at: tableView.indexPathForRow(at: point) ?? [0, 0])
    }
    
    private func topPadding() -> CGFloat {
        return topToolsMaxY() + CGFloat(tableHeaderView.height)
    }
    
    private func getTableViewCenterY() -> CGFloat {
        return tableView.center.y + (topToolsMaxY() / 2)
        
    }
    
    private func topToolsMaxY() -> CGFloat {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Каталог"
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = UIColor.ankPurple
        navigationController?.navigationBar.barTintColor = UIColor.ankPurple
        navigationController?.navigationBar.tintColor = UIColor.black

        
        let attributesForSmallTitle: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.defaultFont(ofSize: 18) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.titleTextAttributes = attributesForSmallTitle
        
        let cartBarButtonItem = UIBarButtonItem(customView: UIViewCartIcon())
        navigationItem.rightBarButtonItem = cartBarButtonItem
        
        if !logoIsHidden {
            let logoView = UIBarButtonItem(customView: UILogoImageView())
            navigationItem.leftBarButtonItem = logoView
        }
    }
    
    @objc private func pushScannerVC() {
        let vc = ScannerViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func refreshTableViewHandler() {
        if !searchController.isActive {
            fetchData()
        }
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.refreshControl = refreshController
        tableView.showsVerticalScrollIndicator = false
        
    }
    
    func setupSearchViewController() {
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.placeholder = "Поиск"
        
        if let bg = searchTextField?.subviews.first {
            bg.backgroundColor = .white
            bg.layer.cornerRadius = 10
            bg.clipsToBounds = true
        }
        
        searchController.searchBar.sizeToFit()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.black
        navigationItem.searchController = searchController
    }
    
    private func registerCells() {
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
                self?.dataLoaded = data
            }
            self?.isLoading = false
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = getData()
        return data.count == 0 ? 1 : data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = prepareCell(forIndexPath: indexPath)
        return cell
    }
    
    func prepareCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        if (isLoading) {
            let cell = tableView.dequeueReusableCell(withIdentifier: placeholderCellId, for: indexPath) as! PlaceholderTableViewCell
            return cell
        }
        let data = getData()
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
    
    private func getData() -> [ProductPreview] {
        return data
    }
    
    let transitionManager = ProductTransitionManager()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data.count == 0 { return }
        let productInfoViewController = ProductInfoTableViewController()
        productInfoViewController.productId = String(Int(data[indexPath.row].id))
        navigationController?.pushViewController(productInfoViewController, animated: true)
    }
}

extension ProductsTableViewController: ProductListToolbarDelegate {
    func didTapButton(_ sender: ProductListToolbar.ProductListToolbarItemType) {
        switch sender {
//        case .sorting:
//            sortingButtonHandler()
        case .filter:
            filterButtonHandler()
        case .codeFind:
            codeFindButtonHandler()
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

    func codeFindButtonHandler() {
        let filterVC = ScannerViewController()
        navigationController?.pushViewController(filterVC, animated: true)
    }
    
}

extension ProductsTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
                  searchText != ""
        else {
            return
        }
        productFinder.find(byString: searchText)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        tableView.beginUpdates()
        headerHeight = 30
        tableView.endUpdates()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        tableView.beginUpdates()
        headerHeight = 0
        tableView.endUpdates()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        guard data.count == dataSearch.count else {
            return
        }
        
        tableView.beginUpdates()
        
        updateTableData(
            deletingData: dataSearch,
            insertingData: dataLoaded,
            insertingAnimaton: .left,
            deletingAnimation: .right
        )
        
        tableView.endUpdates()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
        tableView.beginUpdates()
        
        updateTableData(
            deletingData: dataLoaded,
            insertingData: dataSearch,
            insertingAnimaton: .right,
            deletingAnimation: .left
        )
        
        tableView.endUpdates()
    }
    
    func updateTableData(
        deletingData: [ProductPreview],
        insertingData: [ProductPreview],
        insertingAnimaton: UITableView.RowAnimation,
        deletingAnimation: UITableView.RowAnimation) {
        
        if deletingData.count == 0 {
            tableView.deleteRows(at: [[0, 0]], with: deletingAnimation)
        } else {
            tableView.deleteRows(at: deletingData.enumerated().map({ IndexPath(row: $0.0, section: 0) }), with: deletingAnimation)
        }
        
        if insertingData.count == 0 {
            tableView.insertRows(at: [[0, 0]], with: insertingAnimaton)
        } else {
            tableView.insertRows(at: insertingData.enumerated().map({ IndexPath(row: $0.0, section: 0) }), with: insertingAnimaton)
        }
        
        data = insertingData
        
    }
}

extension ProductsTableViewController: ProductFinderDelegate {
    
    func willSearch(_ finder: ProductFinder) {
        isLoading = true
    }
    
    func didSearch(_ finder: ProductFinder, withProducts products: [ProductPreview], _ queryString: String, _ error: Error?) {
        if error == nil {
            self.dataSearch = products
        }
        self.isLoading = false
    }
}
