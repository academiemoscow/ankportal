//
//  MainPageViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 22/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

let backgroundColor = UIColor(r: 230, g: 230, b: 230)
let sectionUnderlineColor = UIColor(r: 200, g: 200, b: 200)
let lightFirmColor = UIColor(r: 159, g: 131, b: 174)

let heightOfBannerCell:CGFloat = 180
let heightOfNewProductsCell:CGFloat = 150
var firstPageController: UIViewController?

class MainPageViewController: UITableViewController {
    
    let bannerCellId = "bannersCell"
    let newProductsCellId = "newProductsCellId"
    let newsCellId = "newsCellId"
    let educationsCellId = "educationsCellId"
    let brandsCellId = "brandsCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstPageController = self
        
        
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: bannerCellId)
        tableView.register(NewProductsTableViewCell.self, forCellReuseIdentifier: newProductsCellId)
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: newsCellId)
        tableView.register(SeminarsTableViewCell.self, forCellReuseIdentifier: educationsCellId)
        tableView.register(BrandsTableViewCell.self, forCellReuseIdentifier: brandsCellId)

        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = heightOfBannerCell*0.05
        tableView.separatorInset.right = heightOfBannerCell*0.05
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = lightFirmColor
        navigationController?.navigationBar.barTintColor = lightFirmColor
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
            return 180
        case 1:
            return 150
        case 2:
            return 180
        case 3:
            return 300
        case 4:
            return 140
        default:
            return 180
        }
       
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0
        case 1:
            return 40
        case 2:
            return 40
        case 3:
            return 40
        case 4:
            return 40
        default:
            return 40
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerSectionView = UIView()
        footerSectionView.backgroundColor = backgroundColor
        
        let lineView = UIView()
        lineView.layer.borderWidth = 1
        lineView.layer.borderColor = sectionUnderlineColor.cgColor
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        footerSectionView.addSubview(lineView)
        lineView.centerYAnchor.constraint(equalTo: footerSectionView.centerYAnchor).isActive = true
        lineView.leftAnchor.constraint(equalTo: footerSectionView.leftAnchor, constant: 5).isActive = true
        lineView.heightAnchor.constraint(equalTo: footerSectionView.heightAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: footerSectionView.rightAnchor, constant: -5).isActive = true
        
        return footerSectionView
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let sectionView = UIView()
            sectionView.backgroundColor = backgroundColor
            
            let lineView = UIView()
            lineView.layer.borderWidth = 1
            lineView.layer.borderColor = sectionUnderlineColor.cgColor
            lineView.translatesAutoresizingMaskIntoConstraints = false
            
            sectionView.addSubview(lineView)
            lineView.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor).isActive = true
            lineView.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 5).isActive = true
            lineView.heightAnchor.constraint(equalTo: sectionView.heightAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -5).isActive = true
            
            return sectionView
        }
        
        if section == 1 {
            let sectionView = UIView()
            sectionView.backgroundColor = backgroundColor

            let nameLabel = UILabel()
            nameLabel.text = "Новинки"
            nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false

            sectionView.addSubview(nameLabel)
            nameLabel.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 10).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

            return sectionView
        }
        
        if section == 2 {
            let sectionView = UIView()
            sectionView.backgroundColor = backgroundColor
            
            let nameLabel = UILabel()
            nameLabel.text = "События"
            nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            sectionView.addSubview(nameLabel)
            nameLabel.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 10).isActive = true
            return sectionView
        }
        
        if section == 3 {
            let sectionView = UIView()
            sectionView.backgroundColor = backgroundColor
            
            let nameLabel = UILabel()
            nameLabel.text = "Семинары"
            nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            sectionView.addSubview(nameLabel)
            nameLabel.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 10).isActive = true
            
            let settingsShowButtonImageView = UIImageView()
            sectionView.addSubview(settingsShowButtonImageView)
            settingsShowButtonImageView.image = UIImage(named: "filter_barbutton")
            settingsShowButtonImageView.translatesAutoresizingMaskIntoConstraints = false
            settingsShowButtonImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
            settingsShowButtonImageView.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -10).isActive = true
            settingsShowButtonImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            settingsShowButtonImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            return sectionView
        }
        
        if section == 4 {
            let sectionView = UIView()
            sectionView.backgroundColor = backgroundColor
            
            let nameLabel = UILabel()
            nameLabel.text = "Бренды"
            nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            sectionView.addSubview(nameLabel)
            nameLabel.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 10).isActive = true
            return sectionView
        } else {
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.bannerCellId, for: indexPath) as! BannerTableViewCell
            cell.mainPageController = self
            cell.backgroundColor = backgroundColor
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
            cell.backgroundColor = backgroundColor
            return cell
        }
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.educationsCellId, for: indexPath) as! SeminarsTableViewCell
            cell.mainPageController = self
            cell.backgroundColor = backgroundColor
            return cell
        }
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.brandsCellId, for: indexPath) as! BrandsTableViewCell
            cell.mainPageController = self
            cell.backgroundColor = backgroundColor
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = backgroundColor
            return cell
        }
        
    }
    
}
