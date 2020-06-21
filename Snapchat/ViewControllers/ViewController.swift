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
    @IBOutlet weak var btnSignedIn: UIButton!
    @IBOutlet weak var txtPassword2: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setupHideKeyboardOnTap()
        // Do any additional setup after loading the view.
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
   
        
       
    }
 

    @IBAction func btnTurnedUp(_ sender: Any) {
        
       
        
        if (txtEmail.text!.count > 0 && txtEmail.text != "") && (txtPassword2.text!.count > 0 && txtPassword2.text != "")  {
             createSpinnerView()
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword2.text!,completion: { (user, error) in

            print("WE tried to sign in")
            
            if error != nil {
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                               let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                                
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
              
            }else {
                 
                print("Sign in Successfully")
                  self.performSegue(withIdentifier: "showemails", sender: nil)
            }
        })
        }else {
            let alertController = UIAlertController(title: "Uncomplete", message: "Please fill the email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    //showSignup
   //self.performSegue(withIdentifier: "showSignup", sender: nil)
 
    @IBAction func btnRegister(_ sender: Any) {
       self.performSegue(withIdentifier: "showSignup", sender: nil)
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


