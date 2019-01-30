//
//  ViewController.swift
//  Chat
//
//  Created by Олег Рачков on 15/01/2019.
//  Copyright © 2019 Олег Рачков. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "new_dialog")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(r: 100, g: 62, b: 110)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(r: 100, g: 62, b: 110)
        navigationItem.title = "АНК чат"
        
        checkIfUserIsLoggedIn()
        
            }
    
    @objc func handleNewMessage(){
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
             
//                if let dictionary = snapshot.value as? [String: AnyObject] {
                    //self.navigationItem.title = dictionary["name"] as? String
//                }
                
            }, withCancel: nil)
        }
    }
    
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }

}



