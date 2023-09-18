//
//  UIViewController+Menu.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 18/09/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupMenu() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ic_menu"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(onOpenMenu)
        )
    }
    
    @objc private func onOpenMenu() {
        NotificationCenter.default.post(Notification(name: NotificationNameOpenMenu))
    }
    
}
