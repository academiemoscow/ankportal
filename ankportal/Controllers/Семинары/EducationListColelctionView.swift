//
//  EducationListColelctionView.swift
//  
//
//  Created by Олег Рачков on 16/09/2019.
//

import Foundation
import UIKit

class EducationListCollectionView: UICollectionViewInTableViewCell {
    
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
    
    var isLoading = true {
        didSet {
            guard oldValue != self.isLoading else {
                return
            }
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    var data = [EducationPreview]()
    var filteredData = [EducationPreview]()
    
    let layout = UICollectionViewFlowLayout()
    
    private lazy var refreshController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableViewHandler), for: .valueChanged)
        return refreshControl
    }()
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
        
        fetchData()
    }
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        
        registerCells()
        
        
        contentInset.left = contentInsetLeftAndRight
        contentInset.right = contentInsetLeftAndRight
        contentInset.top = contentInsetLeftAndRight
        contentInset.bottom = contentInsetLeftAndRight
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        fetchData()
    }
    
    private func registerCells() {
        self.register(EducationInfoCollectionViewCell.self, forCellWithReuseIdentifier: defaultCellId)
        self.register(EducationInfoPlaceholderCollectionViewCell.self, forCellWithReuseIdentifier: placeholderCellId)
//        self.register(NotFoundEducationTableViewCell.self, forCellReuseIdentifier: notFoundCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func fetchData() {
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
    
    
}

extension EducationListCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.9 - contentInsetLeftAndRight, height: collectionView.frame.height - contentInsetLeftAndRight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ( isLoading ) {
            return filteredData.count == 0 ? 2 : filteredData.count
        } else {
            return filteredData.count == 0 ? 1 : filteredData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        if (isLoading) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: placeholderCellId, for: indexPath) as! EducationInfoPlaceholderCollectionViewCell
            return cell
        }
        guard filteredData.count > 0 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellId, for: indexPath) as! EducationInfoCollectionViewCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellId, for: indexPath) as! EducationInfoCollectionViewCell
        cell.educationInfo = EducationInfoCell()
        
        cell.educationInfo?.educationInfoFromJSON = filteredData[indexPath.row]
        cell.fillCellData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedInfoViewController = EducationDetailedInfoController()
        detailedInfoViewController.educationId = filteredData[indexPath.row].id
        
        firstPageController?.navigationController?.pushViewController(detailedInfoViewController, animated: true)
    }

}
