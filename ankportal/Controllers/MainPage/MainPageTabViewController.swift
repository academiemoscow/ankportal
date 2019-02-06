//
//  File.swift
//  Chat
//
//  Created by Олег Рачков on 24/01/2019.
//  Copyright © 2019 Олег Рачков. All rights reserved.
//

import Foundation
import UIKit



class MainPageController: UITableViewController {
    
    let firstCellId = "bannerCell"
    let secondCellId = "newProductsCell"
    let thirdCellId = "NewsListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        //retrieveNewsList()
        
        navigationItem.title = "Главная"
        
      //  tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 1000
        //navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(MainPageBannerCell.self, forCellReuseIdentifier: firstCellId)
        tableView.register(NewProductsCell.self, forCellReuseIdentifier: secondCellId)
        tableView.register(NewsListCell.self, forCellReuseIdentifier: thirdCellId)
        
//        tableView
    }
    
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightRow: Float = 0
        let image = UIImage(named: "main_page_banner")
        
        if indexPath == [0, 0]{
          //  heightRow = Float((image?.size.height)!)
            heightRow = Float(view.frame.height / 5)
        } else if indexPath == [1, 0] {
            heightRow = Float(view.frame.height / 5)
        } else if indexPath == [2, 0] {
            heightRow = Float((view.frame.height / 5) * 3)
        }
        
        return CGFloat(heightRow)
    }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                     
            let cell: UITableViewCell = {
                var cell = UITableViewCell()
                if indexPath == [0, 0] {
                    let cellBanner = tableView.dequeueReusableCell(withIdentifier: self.firstCellId, for: indexPath) as! MainPageBannerCell
                    cellBanner.selectedBackgroundView?.backgroundColor = UIColor.white
                    cell = cellBanner
                } else if indexPath == [1, 0] {
                    let cellProducts = tableView.dequeueReusableCell(withIdentifier: self.secondCellId, for: indexPath) as! NewProductsCell
                    cellProducts.height = view.frame.height / 5
                    cell = cellProducts
                } else if indexPath == [2, 0] {
                   let  cellNews = tableView.dequeueReusableCell(withIdentifier: self.thirdCellId, for: indexPath) as! NewsListCell
                    cellNews.mainPageController = self
                    cell = cellNews
                  
                }
                return cell
            }()
            
            return cell
        }
}
