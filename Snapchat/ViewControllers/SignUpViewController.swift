//
//  SignUpViewController.swift
//  Snapchat
//
//  Created by Krys Ngabi on 6/21/20.
//  Copyright © 2020 Krys Ngabi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class SignUpViewController: UIViewController {
    //afterSignUpSegue
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword1: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func signedUp(_ sender: Any) {
        if txtPassword.text != txtPassword1.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
                    
        }else {
            createSpinnerView()
           Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!,completion: { (user, error) in

               print("WE tried to create user")

               if error != nil {
                 
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                 
                 alertController.addAction(defaultAction)
                 self.present(alertController, animated: true, completion: nil)
                    
            
               }else {
                let db = Database.database().reference()
                                              
               let users = db.child("users")
               
               users.child(user!.user.uid).child("email").setValue(user!.user.email)

                    print("Created Successfully")
                     self.performSegue(withIdentifier: "afterSignUpSegue", sender: nil)
               }
           })
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
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
}
