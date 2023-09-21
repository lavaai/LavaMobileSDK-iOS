//
//  Navigator.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 12/09/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import UIKit
import LavaSDK

class Navigator {
    
    private let window: UIWindow
    private let guestRootVC: UINavigationController
    private let userRootVC: UINavigationController
    
    static var shared: Navigator!
    
    static func initialize(_ window: UIWindow) {
        shared = Navigator(window)
    }
    
    private init(_ window: UIWindow) {
        self.window = window
        self.guestRootVC = UINavigationController()
        guestRootVC.navigationBar.isHidden = true
        self.userRootVC = UINavigationController()
        userRootVC.navigationBar.isHidden = false
    }
    
    /// Determine which screen should the app opens first
    func goToStartUpScreen() {
        if Lava.shared.getLavaUser() != nil {
            goToToMain()
        } else {
            goToSignIn()
        }
    }
    
    func goToToMain() {
        window.rootViewController = AppContainerViewController.create()
    }
    
    func goToSignIn() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        guestRootVC.viewControllers.removeAll()
        guestRootVC.pushViewController(targetVC, animated: false)
        
        window.rootViewController = guestRootVC
    }
    
    func openProfile(_ nc: UINavigationController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        nc.viewControllers = [
            targetVC
        ]
    }
    
    func openMessages(_ nc: UINavigationController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "MessagesViewController")
        nc.viewControllers = [
            targetVC
        ]
    }
    
    func openDebug(_ nc: UINavigationController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "DebugInfoViewController")
        nc.viewControllers = [
            targetVC
        ]
    }
    
    static func getVideoPlayerVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MinimizedVideoPlayerViewController")
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
}


