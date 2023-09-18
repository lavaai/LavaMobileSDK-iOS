//
//  HomeViewController.swift
//  DemoApp
//
//  Created by sharath on 19/02/16.
//

import UIKit
import LavaSDK


class HomeViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    var currentViewController:UINavigationController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        // Do any additional setup after loading the view.
        getVersionAndBuildNumber()
        setupNavigationBar()
        menuView.transform.tx = -view.frame.size.width
    }
    
    func setupNavigationBar(){
        
        self.navigationItem.title = "Home"
        
        
    }
    
    @objc func toggleSideMenu() {
        guard isFirstViewControllerShown() else {
            _ = currentViewController?.popViewController(animated: true)
            return
        }
        
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "menuPressed"),
            object: nil
        )
    }
    
    
    func getVersionAndBuildNumber() {
        versionLabel.text = Utility.appVersion()
        buildLabel.text = "Project - Swift 5"
    }
    
    func configureLeftToBarButton() {
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "ic_menu")
        if false == isFirstViewControllerShown() {
            self.navigationItem.leftBarButtonItem?.image = UIImage(named: "ic_back")
        }
    }
    
    func isFirstViewControllerShown() -> Bool {
        var isFirst = false
        if let currentViewController = currentViewController {
            isFirst = currentViewController.viewControllers.first ===  currentViewController.viewControllers.last
        }
        return isFirst
    }
    
}

extension HomeViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        configureLeftToBarButton()
    }
}
