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
            return optionalRESTFilters + dateRESTParametres
        }
    }
    
    private var dateRESTParametres: [RESTParameter] = [
        RESTParameter(filter: .educationFilterDateStart, value: "today"),
    ]
    
    var datesArray: [String] = []
    var typesArray: [String] = []
    var citiesArray: [String] = []
    
    var filteredDatesArray: [String] = []
    var filteredTypesArray: [String] = []
    var filteredCitiesArray: [String] = []
    
    var dateFilter: String = ""
    var typeFilter: String = ""
    var cityFilter: String = ""

    var optionalRESTFilters: [RESTParameter] = []
    var optionalRESTFiltersCount: Int {
        get {
            return optionalRESTFilters.map({ (restParameter) -> String in
                return restParameter.name.replacingOccurrences(of: "[<>!]", with: "", options: .regularExpression)
            }).uniqueElementsCount()
        }
    }
    
    lazy var tableHeaderView: EducationListToolbar = {
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
    var filteredData = [EducationPreview]()
    
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
        
        datesArray = []
        typesArray = []
        citiesArray = []
        
        filteredDatesArray = []
        filteredTypesArray = []
        filteredCitiesArray = []
        
        dateFilter = ""
        typeFilter = ""
        cityFilter = ""
        
        tableHeaderView.filterCityButton.setTitle("Город ▾", for: .normal)
        tableHeaderView.filterDateButton.setTitle("Дата ▾", for: .normal)
        tableHeaderView.filterTypeButton.setTitle("Направление ▾", for: .normal)
        
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
        tableView.register(NotFoundEducationTableViewCell.self, forCellReuseIdentifier: notFoundCellId)
    }
    
    func fetchData() {
        isLoading = true
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
            
            self?.setFiltersArrays()
            
            self?.isLoading = false
            
        }
        
    }
    
    func setFiltersArrays() {
        self.typesArray = []
        self.citiesArray = []
        self.datesArray = []
        
        for education in (self.data) {
            if education.type!.count > 0 {
                if education.type?[0] != "" {
                    if !self.typesArray.contains((education.type?[0])!) {
                        self.typesArray.append(education.type![0])
                    }
                }
            }
            if education.town != "" {
                if !self.citiesArray.contains(education.town!) {
                    self.citiesArray.append(education.town!)
                }
            }
            if education.date != "" {
                if !self.datesArray.contains(education.date!) {
                    self.datesArray.append(education.date!)
                }
            }
        }
        
       
        self.typesArray.sort()
        self.typesArray.insert("Все направления", at: 0)
        
        self.citiesArray.sort()
        self.citiesArray.insert("Все города", at: 0)

        self.datesArray.sort()
        self.datesArray.insert("Все даты", at: 0)
        
        filteredTypesArray = typesArray
        filteredCitiesArray = citiesArray
        filteredDatesArray = datesArray
        
        filteredData = data
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( isLoading ) {
            return filteredData.count == 0 ? 4 : filteredData.count
        } else {
            return filteredData.count == 0 ? 1 : filteredData.count
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
        guard filteredData.count > 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: notFoundCellId, for: indexPath) as! NotFoundEducationTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellId, for: indexPath) as! EducationInfoTableViewCell
        cell.educationInfo = EducationInfoCell()
        
        cell.educationInfo?.educationInfoFromJSON = filteredData[indexPath.row]
        cell.configure(forModel: filteredData[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.2 + 24
    }
    
    
    let transitionManager = ProductTransitionManager()
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let detailedInfoViewController = EducationDetailedInfoController()
            detailedInfoViewController.educationId = filteredData[indexPath.row].id
        
            self.navigationController?.pushViewController(detailedInfoViewController, animated: true)

    }
}

extension EducationsTableViewController: EducationListToolbarDelegate {
    
    
    
    func didTapButton(_ sender: EducationListToolbar.EducationListToolbarItemType) {
        switch sender {
        case .sortingTypes:
            sortingTypesButtonHandler()
        case .sortingCities:
            sortingCitiesButtonHandler()
        case .sortingDates:
            sortingDatesButtonHandler()
        }
    }
    
    func sortingTypesButtonHandler() {
        let sortingVC =  UIEducationTypesPickerViewController()
        sortingVC.pickerViewStrings = self.filteredTypesArray
        sortingVC.modalPresentationStyle = .overCurrentContext
        sortingVC.parentTableView = self
        present(sortingVC, animated: true, completion: nil)
    }
    
    func sortingCitiesButtonHandler() {
        let sortingVC =  UIEducationCitiesPickerViewController()
        sortingVC.pickerViewStrings = self.filteredCitiesArray
        sortingVC.modalPresentationStyle = .overCurrentContext
        sortingVC.parentTableView = self
        present(sortingVC, animated: true, completion: nil)
    }
    
    func sortingDatesButtonHandler() {
        let sortingVC =  UIEducationDatesPickerViewController()
        sortingVC.pickerViewStrings = self.filteredDatesArray
        sortingVC.modalPresentationStyle = .overCurrentContext
        sortingVC.parentTableView = self
        present(sortingVC, animated: true, completion: nil)
    }
    
}


