//
//  UIViewController+Alert.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 10/12/2021.
//  Copyright © 2021 CodeCraft Technologies. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
