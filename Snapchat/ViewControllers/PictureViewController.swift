//
//  PictureViewController.swift
//  Snapchat
//
//  Created by Krys Ngabi on 6/19/20.
//  Copyright © 2020 Krys Ngabi. All rights reserved.
//

import UIKit
import Firebase

class PictureViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtDesc: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    var imagePicker = UIImagePickerController()
    var url = ""
    var uid = "\(NSUUID().uuidString)"
    @IBOutlet weak var btnNexxt: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        btnNext.isEnabled = false
        self.setupHideKeyboardOnTap()

        // Do any additional setup after loading the view.
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
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        
        
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func photosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        
        
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imgView.image = image
        imgView.backgroundColor = UIColor.clear
        
        imagePicker.dismiss(animated: true, completion: nil)
         btnNext.isEnabled = true
        //txtDesc.text! =  ""
        
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        btnNext.isEnabled = false
              let storage = Storage.storage()

              let storageRef = storage.reference()
              let imagesFolder = storageRef.child("images")
              
        let img=imgView.image!.jpegData(compressionQuality: 0.1);
              
            let nomImage = "\(uid).jpg"
        
              imagesFolder.child(nomImage).putData(img!, metadata: nil,completion: { (metadata, error) in
                  print ("We tried to upload")
                  if error != nil {
                      print("We had an error : \(error)")
                  }else {
                     
                    let storageRef = imagesFolder.child(nomImage)

                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        if url != nil {
                            //print("ELOKO URL : \(url!.absoluteString)")
                            self.performSegue(withIdentifier: "selectUserSegue", sender:url!.absoluteString)
                                            
                        }
                    })
                        
                    }
              })
        
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let netxVC = segue.destination as! SelectUserViewController
        netxVC.descrip = txtDesc.text!
        netxVC.imageURL = sender as! String
        netxVC.uid = uid
        
        

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
