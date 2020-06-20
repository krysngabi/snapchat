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
    @IBOutlet weak var btnNexxt: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        
        
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imgView.image = image
        imgView.backgroundColor = UIColor.clear
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        txtDesc.text! =  ""
        
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        btnNext.isEnabled = false
              let storage = Storage.storage()

              let storageRef = storage.reference()
              let imagesFolder = storageRef.child("images")
              
        let img=imgView.image!.jpegData(compressionQuality: 0.1);
              
        
              imagesFolder.child("\(NSUUID().uuidString).jpg").putData(img!, metadata: nil,completion: { (metadata, error) in
                  print ("We tried to upload")
                  if error != nil {
                      print("We had an error : \(error)")
                  }else {
                    self.performSegue(withIdentifier: "selectUserSegue", sender: nil)
                  }
              })
        
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        
        
        

    }
}
