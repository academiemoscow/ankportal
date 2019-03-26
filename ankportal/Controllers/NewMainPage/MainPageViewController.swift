//
//  MainPageViewController.swift
//  ankportal
//
//  Created by Олег Рачков on 22/03/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

let rgbBackground:CGFloat = 230
let heightOfBannerCell:CGFloat = 180
let heightOfNewProductsCell:CGFloat = 150
var firstPageController: UIViewController?

class MainPageViewController: UITableViewController {
    
    let firstCellId = "bannersCell" //ячейка с баннером

    
    let logoView: UIImageView = {
       
        let logoView = UIImageView()
        logoView.image = UIImage(named: "logo")
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("!")
        firstPageController = self
        tableView.register(NewProductsTableViewCell.self, forCellReuseIdentifier: firstCellId)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = heightOfBannerCell*0.05
        tableView.separatorInset.right = heightOfBannerCell*0.05
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(r: 101, g: 61, b: 113)
        navigationController?.navigationBar.barTintColor = UIColor(r: 101, g: 61, b: 113)
        
        navigationItem.title = "Академия Научной Красоты"
        
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
            return heightOfNewProductsCell*0.2
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let sectionView = UIView()
            sectionView.backgroundColor = UIColor(r: rgbBackground, g: rgbBackground, b: rgbBackground)

            let nameLabel = UILabel()
            nameLabel.text = "Новинки"
            nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false

            sectionView.addSubview(nameLabel)
            nameLabel.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 10).isActive = true
            return sectionView
        }
        
        if section == 2 {
            let sectionView = UIView()
            sectionView.backgroundColor = UIColor(r: rgbBackground, g: rgbBackground, b: rgbBackground)
            
            let nameLabel = UILabel()
            nameLabel.text = "События"
            nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            sectionView.addSubview(nameLabel)
            nameLabel.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 10).isActive = true
            return sectionView
        }
        
        if section == 3 {
            let sectionView = UIView()
            sectionView.backgroundColor = UIColor(r: rgbBackground, g: rgbBackground, b: rgbBackground)
            
            let nameLabel = UILabel()
            nameLabel.text = "Семинары"
            nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            sectionView.addSubview(nameLabel)
            nameLabel.centerYAnchor.constraint(equalTo: sectionView.centerYAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 10).isActive = true
            return sectionView
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = BanneerTableViewCell()
            cell.mainPageController = self
            cell.backgroundColor = UIColor(r: rgbBackground, g: rgbBackground, b: rgbBackground)
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = NewProductsTableViewCell()
            cell.mainPageController = self
            return cell
        }
        
        if indexPath.section == 2{
            let cell = NewsTableViewCell()
            cell.mainPageController = self
            cell.backgroundColor = UIColor(r: rgbBackground, g: rgbBackground, b: rgbBackground)
            return cell
        }
        if indexPath.section == 3{
            let cell = SeminarsTableViewCell()
            cell.mainPageController = self
            cell.backgroundColor = UIColor(r: rgbBackground, g: rgbBackground, b: rgbBackground)
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor(r: rgbBackground, g: rgbBackground, b: rgbBackground)
            return cell

        }
        
        
    }
}
