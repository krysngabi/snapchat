//
//  ViewController.swift
//  Snapchat
//
//  Created by Krys Ngabi on 6/17/20.
//  Copyright © 2020 Krys Ngabi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnTurnedUp(_ sender: Any) {
       
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!,completion: { (user, error) in

            print("WE tried to sign in")

            if error != nil {
                print("Hey we have an error : \(error)")
                Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!,completion:  { (user, error) in
                    print("We have tried to create a user")

                    if error != nil {
                       print("Hey we have an error : \(error)")

                    }else{
                        print("Created user successfully!")
                        self.performSegue(withIdentifier: "showemails", sender: nil)
                    }
                })
            }else {
                print("Sign in Successfully")
                  self.performSegue(withIdentifier: "showemails", sender: nil)
            }
        })
    }
    
}

