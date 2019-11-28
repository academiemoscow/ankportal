//
//  InformationTableViewController.swift
//  ankportal
//
//  Created by OlegR on 13.11.2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import UIKit

class InformationTableViewController: UITableViewController {
    let aboutCompanyCellId = "aboutCompanyCellId" // о компании
    let videoCellId = "videoCellId" // видео
    let pressCellId = "pressCellId" // новости
    let partnersCellId = "partnersCellId" // партнеры
    let socialNetCellId = "socialNetCellId" // социальные сети
    let contactsCellId = "contactsCellId" // контакты
    
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
           super.viewDidLoad()
           registerCellTypes()
        
        navigationController?.navigationBar.backgroundColor = UIColor.ankPurple
        navigationController?.navigationBar.barTintColor = UIColor.ankPurple
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationItem.title = "Информация"
        
        let attributesForSmallTitle: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.defaultFont(ofSize: 18) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.titleTextAttributes = attributesForSmallTitle
        
        let cartBarButtonItem = UIBarButtonItem(customView: UIViewCartIcon())
        navigationItem.rightBarButtonItem = cartBarButtonItem
        
        let logoView = UIBarButtonItem(customView: UILogoImageView())
        navigationItem.leftBarButtonItem = logoView
       }
       
   fileprivate func registerCellTypes() { // регистрация ячеек tableView главной страницы
       tableView.register(InformationTableViewCell.self, forCellReuseIdentifier: aboutCompanyCellId)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
        }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlString: String = ""
        
        switch indexPath.row {
            case 0:
                urlString = "https://ankportal.ru/about/"
            case 1:
                urlString = "https://ankportal.ru/business/"
            case 2:
                urlString = "https://ankportal.ru/press/"
            case 3:
                urlString = "https://ankportal.ru/video/"
            case 4:
                urlString = "https://ankportal.ru/about/"
            case 5:
                urlString = "https://www.facebook.com/ankportal"
            case 6:
                urlString = "https://ankportal.ru/vakansii/"
            case 7:
                urlString = "https://ankportal.ru/contacts/"
            default:
                urlString = "https://ankportal.ru/about/"
        }
        
        let aboutCompanyView = AboutCompanyViewController()
        aboutCompanyView.url = urlString
        navigationController?.pushViewController(aboutCompanyView, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.aboutCompanyCellId, for: indexPath) as! InformationTableViewCell
        
        var title: String = ""
        switch indexPath.row {
            case 0:
                title = "О Компании"
            case 1:
                title = "Бизнес под ключ"
            case 2:
                title = "Пресса о нас"
            case 3:
                title = "Видеоматериалы"
            case 4:
                title = "Партнеры"
            case 5:
                title = "Социальные сети"
            case 6:
                title = "Вакансии"
            case 7:
                title = "Контакты"
      default:
          title = ""
      }
        cell.titleLabel.text = title
        
        return cell
    }
    
    
}

