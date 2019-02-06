//
//  NewMessageController.swift
//  Chat
//
//  Created by Олег Рачков on 18/01/2019.
//  Copyright © 2019 Олег Рачков. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellId: String = "cellId"
    
   var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(handleCancel))
        
        //tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }

    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            //list of users
            if let dictionary = snapshot.value as? [String: Any] {
                
                
                let user = User()
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                self.tableView.reloadData()
               
            }
        },     withCancel: nil)
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
    
}

//class UserCell: UITableViewCell {
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
