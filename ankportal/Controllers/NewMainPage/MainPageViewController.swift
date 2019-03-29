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

let firmColor = UIColor(r: 101, g: 61, b: 113)
let lightFirmColor = UIColor(r: 107, g: 81, b: 121)
let heightOfBannerCell:CGFloat = 180
let heightOfNewProductsCell:CGFloat = 150
var firstPageController: UIViewController?

class MainPageViewController: UITableViewController {
    
    let bannerCellId = "bannersCell" //ячейка с баннером
    let newProductsCellId = "newProductsCellId" //ячейка с новинками
    let newsCellId = "newsCellId" //
    let educationsCellId = "educationsCellId"
    
    let logoView: UIImageView = {
       
        let logoView = UIImageView()
        logoView.image = UIImage(named: "logo")
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstPageController = self
        
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: bannerCellId)
        tableView.register(NewProductsTableViewCell.self, forCellReuseIdentifier: newProductsCellId)
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: newsCellId)
        tableView.register(SeminarsTableViewCell.self, forCellReuseIdentifier: educationsCellId)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = heightOfBannerCell*0.05
        tableView.separatorInset.right = heightOfBannerCell*0.05
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = firmColor
        navigationController?.navigationBar.barTintColor = firmColor
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationItem.title = "Академия Научной Красоты"
        
        let navigationBarAppearance = self.navigationController!.navigationBar
        navigationBarAppearance.setBackgroundImage(UIImage(named: "find_icon"), for: .compact)
        
        
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

        navigationController?.navigationBar.addSubview(logoView)
        logoView.rightAnchor.constraint(equalTo: (navigationController?.navigationBar.rightAnchor)!, constant: -10).isActive = true
        logoView.bottomAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: -10).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 25).isActive = true
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

        if indexPath.section == 1 {
            return 150
        } else if indexPath.section == 3  {
            return 300
        } else { return 180
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 || section == 3 {
            return 40
        } else {
            return 0
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
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
//            let cell = BannerTableViewCell()
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
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = backgroundColor
            return cell
        }
    }
    
}
