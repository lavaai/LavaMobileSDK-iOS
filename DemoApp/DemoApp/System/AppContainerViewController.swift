//
//  AppContainerViewController.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 12/09/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import UIKit

class AppContainerViewController: UIViewController {
    
    var sidebarVC: SideBarViewController!
    var contentVC: UIViewController!
    
    static func create() -> AppContainerViewController {
        return AppContainerViewController()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sidebarVC = SideBarViewController()
        sidebarVC.view.frame = view.frame
        view.addSubview(sidebarVC.view)
        
        contentVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        contentVC.view.frame = view.frame
        let mainNavController = UINavigationController(rootViewController: contentVC)
        mainNavController.navigationBar.tintColor = UIColor.darkGray
        view.addSubview(mainNavController.view)
    }

}
