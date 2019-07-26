//
//  NewsListCell.swift
//  ankportal
//
//  Created by Олег Рачков on 30/01/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//

import Foundation
import  UIKit





class NewsListCell: UITableViewCell {
    let cellid = "NewsCell"
    var newslist: [News] = []
    var mainPageController: UIViewController?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.frame)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tableView.register(NewsCell.self, forCellReuseIdentifier: self.cellid)
      
        self.addSubview(tableView)
        setupTableView()
        retrieveNewsList()
    }
    
    func setupTableView() {
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
   
        fatalError("init(coder:) has not been implemented")
    }
    

}


extension NewsListCell: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if   self.newslist.count == 0 { return 10 } else {return self.newslist.count}
    }
    
       
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: NewsCell
        
       
        
        cell = tableView.dequeueReusableCell(withIdentifier: self.cellid, for: indexPath) as! NewsCell
         if self.newslist.count > 0 {
        let news = self.newslist[indexPath.row]
        
        let id = news.id
//        let name = news.name
        let date = news.date
        let textPreview = news.textPreview
        
        
        if let imageURL = news.imageURL {
            
            if let image = imageNewsPhotoCache.object(forKey: imageURL as AnyObject) as! UIImage? {
                cell.newsImageView.image = image
            } else {
            if let url = URL(string: imageURL) {
                URLSession.shared.dataTask(with: url,completionHandler: {(data, result, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        cell.newsImageView.image = UIImage(data: data!)
                    }
                    
                }).resume()
            }
            }
        }
        
        cell.id = id
       // cell.newsName = name
        cell.newsDate = date
        cell.textPreview = textPreview
            cell.layoutSubviews()}
        
        return cell
    }
    
    
}
