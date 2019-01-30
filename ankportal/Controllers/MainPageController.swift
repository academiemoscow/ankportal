//
//  File.swift
//  Chat
//
//  Created by Олег Рачков on 24/01/2019.
//  Copyright © 2019 Олег Рачков. All rights reserved.
//

import Foundation
import UIKit

struct News {
    let id: String
    let name: String
    let date: String
    let imageURL: String?
    let textPreview: String
    
    init(json: [String: Any]) {
        id = json["ID"] as? String ?? ""
        name = json["NAME"] as? String ?? ""
        date = json["DISPLAY_ACTIVE_FROM"] as? String ?? ""
        imageURL = json["PREVIEW_PICTURE"] as? String ?? ""
        textPreview = json["PREVIEW_TEXT"] as? String ?? ""
    }
}



class MainPageController: UITableViewController {
    
    let cellid = "newsListCell"
    var newslist: [News] = []
    
    let getXmlTestButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 113, g: 96, b: 133)
        button.setTitle("Тест", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleGetXMLTest), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleGetXMLTest(){
        retrieveNewsList()
    }
    
    
    func setupGetXmlTestButton(){
        getXmlTestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getXmlTestButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        getXmlTestButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        getXmlTestButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        retrieveNewsList()
        
        
        navigationItem.title = "Новости"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(NewsListCell.self, forCellReuseIdentifier: cellid)
        tableView.rowHeight = 110
    }
    
    
    func retrieveNewsList() {
        
        let jsonUrlString = "https://ankportal.ru/rest/index.php?get=newslist"
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        let news = News(json: jsonObj)
                        self?.newslist.append(news)
                    }
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newslist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = self.newslist[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! NewsListCell
      //  let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        
        let id = news.id
        let name = news.name
        let date = news.date
        let textPreview = news.textPreview
//        cell.newsImageView.image = UIImage(named: "else-5")
        
        if let imageURL = news.imageURL {
            if let url = URL(string: imageURL) {
                URLSession.shared.dataTask(with: url,completionHandler: {(data, result, error) in
                    if error != nil {
                        return
                    }
                    DispatchQueue.main.async {
                        cell.newsImageView.image = UIImage(data: data!)
                    }
                    
                }).resume()
            }
        }
        cell.id = id
        cell.newsName = name
        cell.newsDate = date
        cell.textPreview = textPreview
        cell.layoutSubviews()
        
        return cell
    }
    
}

class UserCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
