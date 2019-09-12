//
//  EducationsTableViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 10/09/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class EducationsTableViewController: UITableViewController {
    
    private let defaultCellId = "defaultProductCell"
    private let placeholderCellId = "placeholderProductCell"
    private let notFoundCellId = "notFoundProductCell"
    private let navigationBarColor = UIColor(r: 159, g: 131, b: 174)
    
    private let ankportalREST = ANKRESTService(type: .educationList)
    private var restParametres: [RESTParameter] {
        get {
            return optionalRESTFilters
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
    
    private lazy var tableHeaderView: EducationListToolbar = {
        let toolbar = EducationListToolbar()
        toolbar.delegate = self
        return toolbar
    }()
    
    private lazy var refreshController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableViewHandler), for: .valueChanged)
        return refreshControl
    }()
    
    var data = [EducationPreview]()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    override func viewDidLayoutSubviews() {
        animateVisibleCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func animateVisibleCells() {
//        let tableViewHeightHalf = getTableViewCenterY()
//        tableView.visibleCells.forEach({ (cell) in
//            if let cell = cell as? ProductTableViewCell {
//                let yOffsetless = cell.center.y - tableView.contentOffset.y
//                let distantFromCenter = abs(tableViewHeightHalf - yOffsetless)
//                cell.scalePropertyAnimation.fractionComplete = distantFromCenter / tableViewHeightHalf
//            }
//        })
    }
    
    private var beginDraggingPoint: CGPoint = .zero
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //beginDraggingPoint = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        let tableViewHeightHalf = getTableViewCenterY()
//        let rect = getNearestCellRect(forPoint: targetContentOffset.pointee)
//        let centerY = rect.origin.y + rect.height / 2
//        let calcContentOffsetY = (centerY - tableViewHeightHalf)
//        targetContentOffset.pointee = CGPoint(x: targetContentOffset.pointee.x, y: calcContentOffsetY)
    }
    
    private func getNearestCellRect(forPoint point: CGPoint) -> CGRect {
        let d = Double(point.y / 400)
        let indexPath = IndexPath(row: Int(d.rounded()), section: 0)
        return tableView.rectForRow(at: indexPath)
    }
    
    private func getTableViewCenterY() -> CGFloat {
        return tableView.center.y + ((navigationController?.navigationBar.frame.maxY ?? 0) / 2)
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Семинары и стажировки"
        
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
        
        let cartBarButtonItem = UIBarButtonItem(customView: UIViewCartIcon())
        navigationItem.rightBarButtonItem = cartBarButtonItem
    }
    
    @objc private func pushScannerVC() {
        let vc = ScannerViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func refreshTableViewHandler() {
        fetchData()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.tableHeaderView = tableHeaderView
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.refreshControl = refreshController
        tableView.showsVerticalScrollIndicator = false
        //tableView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    private func registerCells() {
        tableView.register(EducationInfoTableViewCell.self, forCellReuseIdentifier: defaultCellId)
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
            do {
                let data = try JSONDecoder().decode([EducationPreview].self, from: data!)
                self?.data = data
            } catch {
                print(error)
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
            return data.count == 0 ? 6 : data.count
        } else {
            return data.count == 0 ? 1 : data.count
        }
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
        guard data.count > 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: notFoundCellId, for: indexPath) as! NotFoundTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellId, for: indexPath) as! EducationInfoTableViewCell
        cell.educationInfo = EducationInfoCell()
        
        cell.educationInfo?.educationInfoFromJSON = data[indexPath.row]
        cell.configure(forModel: data[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.2 + 24
    }
    
    
    let transitionManager = ProductTransitionManager()
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
            let detailedInfoViewController = EducationDetailedInfoController()
            detailedInfoViewController.educationId = data[indexPath.row].id
        
            self.navigationController?.pushViewController(detailedInfoViewController, animated: true)
        
        //        let product = data[indexPath.row]
        //        let productInfoVC = TestProductDetailViewController()
        //        transitionManager.imageView = prepareCell(forIndexPath: indexPath) as? ProductTableViewCell
        //        productInfoVC.transitioningDelegate = transitionManager
        //        present(productInfoVC, animated: true)
    }
}

extension EducationsTableViewController: EducationListToolbarDelegate {
    
    
    
    func didTapButton(_ sender: EducationListToolbar.EducationListToolbarItemType) {
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


