//
//  MainPageViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 22/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

let contentInsetLeftAndRight:CGFloat = 10

var firstPageController: UIViewController?

class MainPageViewController: UITableViewController {
    var refresher: UIRefreshControl?
    
    let bannerCellId = "bannersCell" // баннеры
    let newProductsCellId = "newProductsCellId" // новинки
    let newsCellId = "newsCellId" // новости
    let educationsCellId = "educationsCellId" // семинары
    let brandsCellId = "brandsCellId" // бренды
    
    let screenSize = UIScreen.main.bounds
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstPageController = self
        
        registerCellTypes()

        setViewDesign()
        
    }
    
    fileprivate func registerCellTypes() { // регистрация ячеек tableView главной страницы
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: bannerCellId)
        tableView.register(NewProductsTableViewCell.self, forCellReuseIdentifier: newProductsCellId)
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: newsCellId)
        tableView.register(SeminarsTableViewCell.self, forCellReuseIdentifier: educationsCellId)
        tableView.register(BrandsTableViewCell.self, forCellReuseIdentifier: brandsCellId)
    }
    
    fileprivate func setViewDesign() { // основные настройки дизайна (отступы, цвета, шрифты)
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(reloadAllData), for: .allEvents)
        tableView.addSubview(refresher!)
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor.ankPurple
        navigationController?.navigationBar.barTintColor = UIColor.ankPurple
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationItem.title = "Академия Научной Красоты"
        
        let attributesForLargeTitle: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = attributesForLargeTitle
        
        let attributesForSmallTitle: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = attributesForSmallTitle
    }
    
    @objc func reloadAllData() {
        refresher?.endRefreshing()
        
        for tableCellSection in 0...4 {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: tableCellSection)) as? UITableViewCellWithCollectionView {
                cell.collectionView.doReload = true
                cell.collectionView.fetchData()
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Академия Научной Красоты"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return screenSize.width / 3
        case 3:
            return (0.2 * pow(screenSize.height, 2)) / screenSize.width
        default:
            return screenSize.height * 0.2
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0
        default:
            return 40
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerSectionView = UIView()
        footerSectionView.backgroundColor = UIColor.backgroundColor
        
        let lineView = createSeparatorLineView()
        
        footerSectionView.addSubview(lineView)
        
        return footerSectionView
    }
    
    fileprivate func createSeparatorLineView() -> UIView {
        let lineView = UIView()
        return lineView
    }
    
    fileprivate func setSeparationLineView(lineView: UIView, parentView: UIView) {
        lineView.layer.borderWidth = 1
        lineView.layer.borderColor = UIColor.sectionUnderlineColor.cgColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        lineView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        lineView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: contentInsetLeftAndRight / 2).isActive = true
        lineView.heightAnchor.constraint(equalTo: parentView.heightAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: -contentInsetLeftAndRight / 2).isActive = true
    }
    

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sectionName: String = ""
        var sectionNameFontSize: CGFloat = 18
        var sectionHeight: CGFloat = 20
        
        switch section {
        case 1:
            sectionName = "Новинки"
        case 2:
            sectionName = "События"
        case 3:
            sectionName = "Семинары"
        case 4:
            sectionName = "Бренды"
        default:
            sectionName = ""
            sectionNameFontSize = 0
            sectionHeight = 0
        }
        
        let sectionView = createHeaderSectionView(sectionName: sectionName, fontSize: sectionNameFontSize, height: sectionHeight)
        
        if section == 3 {
            let settingsShowButtonImageView = UIImageView()
            sectionView.addSubview(settingsShowButtonImageView)
            settingsShowButtonImageView.image = UIImage(named: "filter_barbutton")
            settingsShowButtonImageView.translatesAutoresizingMaskIntoConstraints = false
            settingsShowButtonImageView.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor).isActive = true
            settingsShowButtonImageView.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -10).isActive = true
            settingsShowButtonImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            settingsShowButtonImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        return sectionView
        
    }
    
    fileprivate func createHeaderSectionView(sectionName: String, fontSize: CGFloat, height: CGFloat) -> UIView {
        let sectionView = UIView()
        sectionView.backgroundColor = UIColor.backgroundColor
        
        let nameLabel = createSectionNameLabel(sectionName: sectionName, fontSize: fontSize)
        sectionView.addSubview(nameLabel)
        setSectionNameLabel(sectionNameLabel: nameLabel, parentView: sectionView, height: height)
        return sectionView
    }
    
    fileprivate func createSectionNameLabel(sectionName: String, fontSize: CGFloat) -> UILabel {
        let sectionNameLabel = UILabel()
        sectionNameLabel.text = sectionName
        sectionNameLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        sectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return sectionNameLabel
    }
    
    fileprivate func setSectionNameLabel (sectionNameLabel: UILabel, parentView: UIView, height: CGFloat) {
        sectionNameLabel.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        sectionNameLabel.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: contentInsetLeftAndRight).isActive = true
        sectionNameLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.bannerCellId, for: indexPath) as! BannerTableViewCell
            cell.mainPageController = self
            cell.backgroundColor = UIColor.backgroundColor
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.newProductsCellId, for: indexPath) as! NewProductsTableViewCell
            cell.mainPageController = self
            return cell
        }
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.newsCellId, for: indexPath) as! NewsTableViewCell
            cell.mainPageController = self
            cell.backgroundColor = UIColor.backgroundColor
            return cell
        }
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.educationsCellId, for: indexPath) as! SeminarsTableViewCell
            cell.mainPageController = self
            cell.backgroundColor = UIColor.backgroundColor
            return cell
        }
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.brandsCellId, for: indexPath) as! BrandsTableViewCell
            cell.mainPageController = self
            cell.backgroundColor = UIColor.backgroundColor
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.backgroundColor
            return cell
        }
        
    }
    
}

