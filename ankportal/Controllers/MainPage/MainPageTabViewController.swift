//
//  File.swift
//  Chat
//
//  Created by Олег Рачков on 24/01/2019.
//  Copyright © 2019 Олег Рачков. All rights reserved.
//

import Foundation
import UIKit

struct NewsList {
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
    var newslist: [NewsList] = []
    
   var refresher: UIRefreshControl?
    
    let firstCellId = "bannerCell"
    let secondCellId = "newProductsCell"
    let thirdCellId = "NewsListCell"
    
    var timer:Timer!
    var numBanner:Int = 0
    var key: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Главная"
        
        tableView.separatorStyle = .none
        
        tableView.register(MainPageBannerCell.self, forCellReuseIdentifier: firstCellId)
        tableView.register(NewProductsCell.self, forCellReuseIdentifier: secondCellId)
        tableView.register(NewsCell.self, forCellReuseIdentifier: thirdCellId)
        
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(reloadAllData), for: .allEvents)
        view.addSubview(refresher!)
        
        retrieveNewsList()
        
        timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func reloadAllData() {
        refresher?.endRefreshing()
        tableView.reloadData()
    }
    
    func retrieveNewsList() {
        let jsonUrlString = "https://ankportal.ru/rest/index.php?get=newslist"
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        let news = NewsList(json: jsonObj)
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
        
    }//retrieveNewsList End
    
    @objc func timerAction() {
        let indexPath = IndexPath(row: 0, section: 0)
        numBanner+=1
        if numBanner>9 {numBanner = 0}
        tableView.reloadRows(at: [indexPath], with: .fade)
       
    }
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 2 {return newslist.count} else {return 1}
        }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightRow: Float = 0
        if indexPath.section == 0{
            heightRow = Float(view.frame.height / 5)
        } else if indexPath.section == 1 {
            heightRow = Float(view.frame.height / 5)
        } else if indexPath.section == 2 {
           heightRow = Float((view.frame.width)*1.03)
            //*0.64 )
        }
        
        return CGFloat(heightRow)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = self.newslist[indexPath.row]
        showNewsDetailedInfoController(newsId: news.id)
    }
    
    func showNewsDetailedInfoController(newsId: String) {
        let newsDetailedInfoController = NewsDetailedInfoController()
        newsDetailedInfoController.newsId = newsId
        self.navigationController?.pushViewController(newsDetailedInfoController, animated: true)
        //newsDetailedInfoController.
        //show(newsDetailedInfoController, sender: nil)
        //tableViewpresent(newsDetailedInfoController, animated: true, completion: nil)
    }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                     
            let cell: UITableViewCell = {
                var cell = UITableViewCell()
                if indexPath.section == 0 {
                    let cellBanner = tableView.dequeueReusableCell(withIdentifier: self.firstCellId, for: indexPath) as! MainPageBannerCell
                    cellBanner.bannerImageView.image = UIImage(named: "mp_banner_" + String(numBanner))
                    cell = cellBanner
                } else if indexPath.section == 1 {
                    let cellProducts = tableView.dequeueReusableCell(withIdentifier: self.secondCellId, for: indexPath) as! NewProductsCell
                    cellProducts.height = view.frame.height / 5
                    cell = cellProducts
                } else if indexPath.section == 2 {
                   let  cellNews = tableView.dequeueReusableCell(withIdentifier: self.thirdCellId, for: indexPath) as! NewsCell
                   cellNews.mainPageController = self
                    if self.newslist.count > 0 {
                        let news = self.newslist[indexPath.row]
                        
                        let id = news.id
                        let name = news.name
                        let date = news.date
                        let textPreview = news.textPreview
                        
                        if let imageURL = news.imageURL {
                            
                            if let image = imageNewsPhotoCache.object(forKey: imageURL as AnyObject) as! UIImage? {
                                cellNews.newsImageView.image = image
                            } else {
                                if let url = URL(string: imageURL) {
                                    URLSession.shared.dataTask(with: url,completionHandler: {(data, result, error) in
                                        if error != nil {
                                            print(error!)
                                            return
                                        }
                                        DispatchQueue.main.async {
                                            cellNews.newsImageView.image = UIImage(data: data!)
                                            cellNews.newsTextPlaceholderView.isHidden = true
                                        }
                                        
                                    }).resume()
                                }
                            }
                        }
                        
                        cellNews.id = id
                        cellNews.newsName = name + "\n\n" + date
                        cellNews.newsDate = date
                        cellNews.textPreview = textPreview
                        cellNews.layoutSubviews()}
                        cell = cellNews
                }
                cell.selectionStyle = .none
                
                return cell
            }()
            
            return cell
        }
}
