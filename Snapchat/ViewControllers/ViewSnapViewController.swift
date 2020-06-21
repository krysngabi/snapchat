//
//  ViewSnapViewController.swift
//  Snapchat
//
//  Created by Krys Ngabi on 6/20/20.
//  Copyright © 2020 Krys Ngabi. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
class ViewSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    var snap = Snap()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl.text = snap.description
        imageView.sd_setImage(with: URL(string: snap.imageURL), completed: nil)

    }
    

    override func viewWillDisappear(_ animated: Bool) {
       let db = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        .child("snaps").child(snap.key).removeValue()
        
        let storage = Storage.storage().reference().child("images").child("\(snap.uuid).jpg")

        storage.delete { (error) in
            print("We deleted the pic")
        }
        
    }

}
