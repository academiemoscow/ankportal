//
//  File.swift
//  Chat
//
//  Created by Олег Рачков on 24/01/2019.
//  Copyright © 2019 Олег Рачков. All rights reserved.
//

import Foundation
import UIKit


struct NewsList_old {
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

class MainPageController_old: UITableViewController {
    var newslist: [NewsList] = []
    
    var refresher: UIRefreshControl?
    
    let firstCellId = "bannerCell"
    let secondCellId = "newProductsCell"
    let thirdCellId = "NewsListCell"
    let fourthCellId = "NextNewsCell"
    
    var timer:Timer!
    var numBanner:Int = 0
    var key: Bool = false
    
    var keyNews: Bool = false
    var newsShowCount: Int = 2
    let stepNewsShowCount = 2
    var loadMoreNewsStatus: Bool = false
    var firstStep: Bool = true
    
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
        
        self.tableView.tableFooterView?.isHidden = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+10", style: .plain, target: self, action: #selector(handlePlus10News))
        retrieveNewsList()
        
        
        timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func handlePlus10News() {
        newsShowCount+=stepNewsShowCount
        tableView.reloadData()
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
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
        loadMoreNews()
    }//retrieveNewsList End
    
    @objc func timerAction() {
        numBanner+=1
        if numBanner>9 {numBanner = 0}
        let cell = tableView.cellForRow(at: [0, 0])
        if cell?.frame != nil {tableView.reloadSections([0], with: .fade)}
    }
    
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 2 {return newsShowCount+1} else {return 1}//newslist.count
        }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightRow: Float = 0
        if indexPath.section == 0{
            heightRow = Float(view.frame.height / 5)
        } else if indexPath.section == 1 {
            heightRow = Float(view.frame.height / 5)
        } else if indexPath.section == 2 && indexPath.row<newsShowCount{
           heightRow = Float((view.frame.width)*1.03)
            //*0.64 )
        } else  if indexPath.section == 2 && indexPath.row == newsShowCount {
            heightRow = Float(60)
        }
        return CGFloat(heightRow)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = self.newslist[indexPath.row]
        if indexPath.section == 2 {
            showNewsDetailedInfoController(newsId: news.id) }

        }
    
    
    func showNewsDetailedInfoController(newsId: String) {
        let newsDetailedInfoController = NewsDetailedInfoController()
        newsDetailedInfoController.newsId = newsId
        self.navigationController?.pushViewController(newsDetailedInfoController, animated: true)
    }
    
 
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 {
            loadMoreNews()
        }
        }
    
    
    func loadMoreNews(){
        if (!loadMoreNewsStatus) && newslist.count>0  {
            loadMoreNewsStatus = true
            
            tableView.performBatchUpdates({ () -> Void in
                
                var indexPaths = [IndexPath]()
                for i in 0...stepNewsShowCount-1 {
                    indexPaths.append(IndexPath(row:newsShowCount+i, section:2))
                    let news = newslist[newsShowCount+i]
                    
                    if let imageURL = news.imageURL {
                        if let url = URL(string: imageURL) {
                            URLSession.shared.dataTask(with: url,completionHandler: {(data, result, error) in
                                if error != nil {
                                    print(error!)
                                    return
                                }
//                                DispatchQueue.main.async {
                                    let image = UIImage(data: data!)
                                    imageNewsPhotoCache.setObject(image!, forKey: imageURL as AnyObject)
//                                    self.tableView.reloadData()
                                    print("new image in cache")
                                
                                                    DispatchQueue.main.async {
                                                        self.tableView.reloadData()
                                                    }
//                                }
                            
                            }).resume()
                        }
                    }
                }
                newsShowCount+=stepNewsShowCount
                tableView.insertRows(at: indexPaths, with: .fade)
               
            }, completion:{ (isComplete) in
                if isComplete {
                    self.loadMoreNewsStatus = false
                        }
            }
            )
           
        }
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
                    cell = cellProducts
                } else if indexPath.section == 2 {
                      if self.newslist.count>0 { if  indexPath.row<newsShowCount {
                        
                        let  cellNews = tableView.dequeueReusableCell(withIdentifier: self.thirdCellId, for: indexPath) as! NewsCell
                        cellNews.mainPageController = self
                        let news = self.newslist[indexPath.row]
                        let id = news.id
                        let name = news.name
                        let date = news.date
                        let textPreview = news.textPreview
                        let imageURL = news.imageURL
//                        print(news.id)
                        cellNews.newsImageView.image = UIImage(named: "newslist_placeholder")
                        if let image = imageNewsPhotoCache.object(forKey: imageURL as AnyObject)  {
                            cellNews.newsImageView.image = image as? UIImage
                            print("main: " + name)
                            
                        } else {print("main: empty")}
                         DispatchQueue.main.async {
                            if let image = imageNewsPhotoCache.object(forKey: imageURL as AnyObject)  {
                                        cellNews.newsImageView.image = image as? UIImage
                                print("dispatch: " + name)
                            } else {print("dispatch: empty")}
                        }
//                        cellNews.newsImageView.url
                        cellNews.id = id
                    //    cellNews.newsName = String(indexPath.row) + "\n" + name + "\n\n" + date
                        cellNews.newsDate = date
                        cellNews.textPreview = textPreview
                        cellNews.layoutSubviews()
                        
                        cell = cellNews
                        
                    }
                }
                    
                }
                cell.selectionStyle = .none
                
                return cell
            }()
            
            return cell
        }
}
