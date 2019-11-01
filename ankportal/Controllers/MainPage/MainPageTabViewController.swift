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
    let id: Float
    let name: String
    let date: String
    let imageURL: String?
    let textPreview: String
    
    
    init(json: [String: Any]) {
        id = json["ID"] as? Float ?? 0
        name = json["NAME"] as? String ?? ""
        date = json["DISPLAY_ACTIVE_FROM"] as? String ?? ""
        imageURL = json["PREVIEW_PICTURE"] as? String ?? ""
        textPreview = json["PREVIEW_TEXT"] as? String ?? ""
    }
}

class MainPageController: UITableViewController {
    var newslist: [NewsList] = []
    
    var refresher: UIRefreshControl?
    
    let firstCellId = "bannerCell" //ячейка с баннером
    let secondCellId = "newProductsCell" //новинки
    let thirdCellId = "NewsListCell" // новости
    
    var timer:Timer! //таймер смены баннера
    var numBanner:Int = 0 //номер картинки с баннером
    
    let startNewsShowCount: Int = 5
    var currentNewsCount = 0
    var loadMoreNewsStatus: Bool = false
    var firstStep: Bool = true
    
    var tmpUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveNewsList()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Главная"
        tableView.contentInset.top = 6
        let navigationControllerHeight: CGFloat = (self.navigationController?.navigationBar.frame.size.height)! - 10
        let navigationControllerWidth: CGFloat = (self.navigationController?.navigationBar.frame.size.width)! - 100
        let pageNameLabel: UITextView = {
            let label = UITextView()
            label.backgroundColor = UIColor(r: 101, g: 61, b: 113)
            label.font = UIFont.systemFont(ofSize: 18)
            label.layer.cornerRadius = 10
            label.textColor = UIColor.white
            label.textAlignment = NSTextAlignment.center
            label.text = "Главная"
            label.isSelectable = false
            label.isEditable = false
            return label
        }()
        pageNameLabel.frame = CGRect(x: 0, y: 0, width: navigationControllerWidth, height: navigationControllerHeight)
        self.navigationItem.titleView = pageNameLabel
        
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        tableView.register(MainPageBannerCell.self, forCellReuseIdentifier: firstCellId)
        tableView.register(NewProductsCell.self, forCellReuseIdentifier: secondCellId)
        tableView.register(NewsCell.self, forCellReuseIdentifier: thirdCellId)
        
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(reloadAllData), for: .allEvents)
        view.addSubview(refresher!)
        
        self.tableView.tableFooterView?.isHidden = true
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 5
        tableView.separatorInset.right = 5
        tableView.separatorColor = UIColor.black
        
        timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func reloadAllData() {
        refresher?.endRefreshing()
        newslist = []
        if newslist.count == 0 {retrieveNewsList()}
        tableView.reloadData()
    }
    
    func retrieveNewsList() {
        let jsonUrlString = "https://ankportal.ru/rest/index.php?get=newslist&pagesize=" + String(startNewsShowCount)
        guard let url: URL = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
            guard let data = data else { return }
            do {
                if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                    for jsonObj in jsonCollection {
                        let news = NewsList(json: jsonObj)
                        self?.newslist.append(news)
                        self!.currentNewsCount+=1
                    }
                    self?.loadMoreNewsToShow()
                }
            } catch let jsonErr {
                print (jsonErr)
            }
            }.resume()
    }
    
    func loadMoreNewsToShow(){
        var jsonUrlString: String = ""
        if (!loadMoreNewsStatus)  {
            loadMoreNewsStatus = true
            if currentNewsCount>0 {
                jsonUrlString = "https://ankportal.ru/rest/index.php?get=newslist&pagesize=" + String(startNewsShowCount) + "&PAGEN_1=" + String((currentNewsCount / 5)+1) } else {
                loadMoreNewsStatus = false
                return
            }
            if tmpUrl == jsonUrlString {
                loadMoreNewsStatus = false
                return
            }
            tmpUrl = jsonUrlString
            guard let url: URL = URL(string: jsonUrlString) else {return}
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, err) in
                guard let data = data else { return }
                do {
                    if let jsonCollection = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                        for jsonObj in jsonCollection {
                            let news = NewsList(json: jsonObj)
                            self?.newslist.append(news)
                            self?.currentNewsCount+=1
                        }
                    }
                } catch let jsonErr {
                    print (jsonErr)
                }
                }.resume()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.loadMoreNewsStatus = false
        }
    }
    
    @objc func timerAction() {
        numBanner+=1
        if numBanner>9 {numBanner = 0}
        let cell = tableView.cellForRow(at: [0, 0])
        if cell?.frame != nil {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            if newslist.count > 0 {return newslist.count} else {return 3}
        }
        else {return 1}
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightRow: CGFloat = 180
        if indexPath.section == 2 {
            heightRow = 160
        }
        return heightRow
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = self.newslist[indexPath.row]
        if indexPath.section == 2 {
            showNewsDetailedInfoController(newsId: String(news.id)) }
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
                cell = cellProducts
            } else if indexPath.section == 2 {
                if self.newslist.count>0  {
                    let cellNews = tableView.dequeueReusableCell(withIdentifier: self.thirdCellId, for: indexPath) as! NewsCell
                    
                    cellNews.backgroundColor = UIColor.white
                    
                    cellNews.mainPageController = self
                    let news = self.newslist[indexPath.row]
                    let id = news.id
                    let name = news.name
                    let date = news.date
                    let textPreview = news.textPreview
                    let imageURL = news.imageURL
                    cellNews.newsNamePlaceholder.isHidden = true
                    cellNews.newsImageView.image = UIImage(named: "newslist_placeholder")
                    
                    if let image = imageNewsPhotoCache.object(forKey: imageURL as AnyObject)  {
                        cellNews.newsImageView.image = image as? UIImage
                    } else {
                        if imageURL != nil {
                            if let url = URL(string: imageURL!) {
                                URLSession.shared.dataTask(with: url, completionHandler: {(data, result, error) in
                                    if error != nil {
                                        print(error!)
                                        return
                                    }
                                    let image = UIImage(data: data!)
                                    imageNewsPhotoCache.setObject(image!, forKey: imageURL as AnyObject)
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }).resume()
                            }
                        }
                    }
                    cellNews.id = String(id)
                    
                    cellNews.newsName = name
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
