//
//  File.swift
//  Chat
//
//  Created by Олег Рачков on 24/01/2019.
//  Copyright © 2019 Олег Рачков. All rights reserved.
//

import Foundation
import UIKit


var imageNewsPhotoCache = NSCache<AnyObject, AnyObject>()

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
    var newsListToShow: [NewsList] = []
    
    var refresher: UIRefreshControl?
    
    let firstCellId = "bannerCell" //ячейка с баннером
    let secondCellId = "newProductsCell" //новинки
    let thirdCellId = "NewsListCell" // новости
    
    var timer:Timer! //таймер смены баннера
    var numBanner:Int = 0 //номер картинки с баннером
    
    let starnNewsShowCount: Int = 5
    let stepNewsShowCount = 1
    var loadMoreNewsStatus: Bool = false
    var firstStep: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveNewsList()
        
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
                        if (self?.newslist.count)!<(self?.starnNewsShowCount)! { self?.newsListToShow.append(news)}
                    }
                                        DispatchQueue.main.async {
                                            self?.tableView.reloadData()
                                        }
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
      
        loadMoreNewsToShow()
    }//retrieveNewsList End
    
    func loadMoreNewsToShow(){
        if (!loadMoreNewsStatus) && newslist.count>0 {
            loadMoreNewsStatus = true
            let newsShowCount = newsListToShow.count
            for i in 0...stepNewsShowCount-1 {
                let currentNews = newslist[newsShowCount+i]
                self.newsListToShow.append(currentNews)
               
//                if let imageURL = currentNews.imageURL {
//                    if let url = URL(string: imageURL) {
//                        URLSession.shared.dataTask(with: url,completionHandler: {(data, result, error) in
//                            if error != nil {
//                                print(error!)
//                                return
//                            }
//                            let image = UIImage(data: data!)
//                            imageNewsPhotoCache.setObject(image!, forKey: imageURL as AnyObject)
//                        }).resume()
//                    }
//                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
////                    self.tableView.performBatchUpdates({ () -> Void in
//                        var indexPaths = [IndexPath]()
//                        indexPaths.append(IndexPath(row:newsShowCount, section:2))
//                        self.tableView.insertRows(at: indexPaths, with: .fade)
//                        newsShowCount+=1
//                    }, completion:{ (isComplete) in
//                        if isComplete {
//
//                        }
//                    }
//                    )
        }
          
//            tableView.reloadData()
            
                loadMoreNewsStatus = false
        }
        }
    
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
        if section == 2 {return newsListToShow.count} else {return 1}//newslist.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //высота строк
        var heightRow: Float = 0
        if indexPath.section == 0{
            heightRow = Float(view.frame.height / 5)
        } else if indexPath.section == 1 {
            heightRow = Float(view.frame.height / 5)
        } else if indexPath.section == 2 {
            heightRow = Float((view.frame.width)*1.03)
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 {
            loadMoreNewsToShow()
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
                cellProducts.height = view.frame.height / 5
                cell = cellProducts
            } else if indexPath.section == 2 {
                if self.newsListToShow.count>0  {
                    print(indexPath)
                    let  cellNews = tableView.dequeueReusableCell(withIdentifier: self.thirdCellId, for: indexPath) as! NewsCell
                    cellNews.mainPageController = self
                    
                    let news = self.newsListToShow[indexPath.row]
                    let id = news.id
                    let name = news.name
                    let date = news.date
                    let textPreview = news.textPreview
                    let imageURL = news.imageURL
                    cellNews.newsImageUrl = imageURL
                    
//                    cellNews.newsImageView.image = UIImage(named: "newslist_placeholder")
//                    
//                    if let image = imageNewsPhotoCache.object(forKey: imageURL as AnyObject)  {
//                        cellNews.newsImageView.image = image as? UIImage
//                    } else {
//                        
//                    }
//                    
//                        if let image = imageNewsPhotoCache.object(forKey: imageURL as AnyObject)  {
//                            cellNews.newsImageView.image = image as? UIImage
//                            print("cache: " + name)
//                        } else {
//                            print("cache is empty: " + name)
//                            print(news.imageURL as Any)
//                            if let imageURL = news.imageURL {
//                                if let url = URL(string: imageURL) {
//                                    URLSession.shared.dataTask(with: url,completionHandler: {(data, result, error) in
//                                        if error != nil {
//                                            print(error!)
//                                            return
//                                        }
//                                        let image = UIImage(data: data!)
//                                        imageNewsPhotoCache.setObject(image!, forKey: imageURL as AnyObject)
//                                        DispatchQueue.main.async {
//                                            cellNews.newsImageView.image = image
//                                        }
//                                    }).resume()
//                                }
//                            }
//                        }
                    
                    cellNews.id = id
                    cellNews.newsName = String(indexPath.row) + "\n" + name + "\n\n" + date
                    cellNews.newsDate = date
                    cellNews.textPreview = textPreview
                    cellNews.layoutSubviews()
                    
                    cell = cellNews
                }
            }
            cell.selectionStyle = .none
            return cell
        }()
        
        return cell
    }
}
