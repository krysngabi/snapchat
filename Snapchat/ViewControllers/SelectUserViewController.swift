//
//  SelectUserViewController.swift
//  Snapchat
//
//  Created by Krys Ngabi on 6/20/20.
//  Copyright © 2020 Krys Ngabi. All rights reserved.
//

import UIKit
import Firebase

class SelectUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tabView: UITableView!
    var users : [User] = []
    var imageURL = ""
    var descrip = ""
    var uid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ESIMBI")
        
        self.tabView.delegate = self
        self.tabView.dataSource = self
        
        let db = Database.database().reference().child("users")
        
            db.observe(DataEventType.childAdded,  with:{ (snapshot) in
            print(snapshot)
            let user = User()
            
            let value = snapshot.value as? NSDictionary
            let emailUser = value!["email"] as? String
            user.email = emailUser!
            
            let dictValues = [String](arrayLiteral: snapshot.key)
            print(dictValues)
           
            
            user.uid = dictValues[0]
            self.users.append(user)
            self.tabView.reloadData()
            
        })
        
         

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let user = users[indexPath.row]
        let snap = ["from":Auth.auth().currentUser!.email,"description":descrip,"imageURL":imageURL,"uuid":uid]
        
        let db = Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
        
        navigationController?.popToRootViewController(animated: true)
     
    }

}
