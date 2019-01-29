//
//  CustomTabBarController.swift
//  Chat
//
//  Created by Олег Рачков on 23/01/2019.
//  Copyright © 2019 Олег Рачков. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(r: 100, g: 62, b: 110)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)

        
        viewControllers = [createNavControllerWithTitle(title: "главная", selectedImageName: "mainpage+01", deselectedImageName: "mainpage-1"),createNavControllerWithTitle(title: "каталог", selectedImageName: "catalog+02", deselectedImageName: "catalog-2"),createNavControllerWithTitle(title: "обучение", selectedImageName: "education+04", deselectedImageName: "education-4"),createNavControllerWithTitle(title: "чат", selectedImageName: "chat+03", deselectedImageName: "chat-3"),createNavControllerWithTitle(title: "прочее", selectedImageName: "else+05", deselectedImageName: "else-5")] as? [UIViewController]
    }
    
    private func createNavControllerWithTitle(title: String, selectedImageName: String, deselectedImageName: String) -> UINavigationController?{
        var viewController: UIViewController?
        switch title {
            case "главная": viewController = MainPageController()
                //UINavigationController(rootViewController: MainPageController())
            case "каталог": viewController = CatalogController()
            case "обучение": viewController = EducationController()
            case "чат": viewController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            case "прочее": viewController = ElseController()
        default:
            break
        }
        
        viewController?.title = title
        viewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: nil)
        
        let image = UIImage(named: "find_icon")
        viewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        
        viewController?.navigationItem.rightBarButtonItem?.tintColor = UIColor(r: 100, g: 62, b: 110)
        viewController?.navigationItem.leftBarButtonItem?.tintColor = UIColor(r: 100, g: 62, b: 110)
        
        
        var navController: UINavigationController?
        if let vc = viewController {
            navController = UINavigationController(rootViewController: vc)
        }
    
        navController?.tabBarItem.title = title
        
        let rect = CGRect(x: 0, y: 0, width: 25, height: 25)
        let rectSelect = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let selectedImage1 = UIImage(named: deselectedImageName)?.withRenderingMode(.alwaysOriginal)
        let deselectedImage1 = UIImage(named: deselectedImageName)?.withRenderingMode(.alwaysOriginal)
        UIGraphicsBeginImageContext(rect.size)
        deselectedImage1?.draw(in: rect)
        let rdeselectedImage1 = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsBeginImageContext(rectSelect.size)
        selectedImage1?.draw(in: rectSelect)
        let rselectedImage1 = UIGraphicsGetImageFromCurrentImageContext()
        
        navController?.tabBarItem.image = rdeselectedImage1
        navController?.tabBarItem.selectedImage = rselectedImage1
        return navController
    }
    
    func loadNewView() {
        
        
        
    }
    
    
    
    
}
