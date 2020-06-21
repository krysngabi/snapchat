//
//  SpinnerViewController.swift
//  Snapchat
//
//  Created by Krys Ngabi on 6/21/20.
//  Copyright © 2020 Krys Ngabi. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {

     var spinner = UIActivityIndicatorView(style: .whiteLarge)

      override func loadView() {
          view = UIView()
          view.backgroundColor = UIColor(white: 0, alpha: 0.7)

          spinner.translatesAutoresizingMaskIntoConstraints = false
          spinner.startAnimating()
          view.addSubview(spinner)

          spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
          spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      }
   
}
