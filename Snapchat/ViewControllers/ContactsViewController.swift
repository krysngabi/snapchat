//
//  ContactsViewController.swift
//  Snapchat
//
//  Created by Krys Ngabi on 6/18/20.
//  Copyright © 2020 Krys Ngabi. All rights reserved.
//

import UIKit
import Firebase
class ContactsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tabView: UITableView!
    var snaps : [Snap] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabView.delegate = self
        tabView.dataSource = self
        
        createSpinnerView()
        
        let db = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
            .child("snaps")
        
            db.observe(DataEventType.childAdded,  with:{ (snapshot) in
           
            let snap = Snap()

            let value = snapshot.value as? NSDictionary
                
            //print("ELOKO VALEUR \(snapshot)")
            let emailUser = value!["from"] as? String
            let imgURL = value!["imageURL"] as? String
            let desc = value!["description"] as? String
            let uuid = value!["uuid"] as? String
            snap.imageURL = imgURL!
            snap.from = emailUser!
            snap.description = desc!
            snap.key = snapshot.key
            snap.uuid = uuid!

                self.snaps.append(snap)
                self.tabView.reloadData()
        })
        
        db.observe(DataEventType.childRemoved,  with:{ (snapshot) in
                
            var index = 0
            for snap in self.snaps {
                if snap.key == snapshot.key {
                    self.snaps.remove(at: index)
                }
                index += 1
                 self.tabView.reloadData()
            }
               })
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        do {
               try Auth.auth().signOut()
           }
        catch let signOutError as NSError {
               print ("Error signing out: %@", signOutError)
           }
           
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let initial = storyboard.instantiateInitialViewController()
           UIApplication.shared.keyWindow?.rootViewController = initial
        //dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0 {
            return 1
        }else {
        return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
       
       
        
        if snaps.count == 0 {
            cell.textLabel?.text = "you have no snaps 😐!!!"
        }else {
         let snap = snaps[indexPath.row]
        cell.textLabel?.text = snap.from
            
        let url = URL(string: snap.imageURL)
        let data = try? Data(contentsOf: url!)
        cell.imageView?.image =  UIImage(data: data!)
        
        }
        let itemSize = CGSize.init(width: 30, height: 30)
               UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
               let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
               cell.imageView?.image?.draw(in: imageRect)
               cell.imageView?.image? = UIGraphicsGetImageFromCurrentImageContext()!;
               UIGraphicsEndImageContext();
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewsnapSegue", sender: snap)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewsnapSegue" {
        let nextVC = segue.destination as! ViewSnapViewController
        nextVC.snap = sender as! Snap
        }
    }
   func createSpinnerView() {
          let child = SpinnerViewController()

          // add the spinner view controller
          addChild(child)
          child.view.frame = view.frame
          view.addSubview(child.view)
          child.didMove(toParent: self)

          // wait two seconds to simulate some work happening
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              // then remove the spinner view controller
              child.willMove(toParent: nil)
              child.view.removeFromSuperview()
              child.removeFromParent()
          }
      }

}
