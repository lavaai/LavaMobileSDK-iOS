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
    private let guessRootVC: UINavigationController
    private let userRootVC: UINavigationController
    
    static var shared: Navigator!
    
    static func initialize(_ window: UIWindow) {
        shared = Navigator(window)
    }
    
    private init(_ window: UIWindow) {
        self.window = window
        self.guessRootVC = UINavigationController()
        guessRootVC.navigationBar.isHidden = true
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
        guessRootVC.viewControllers.removeAll()
        guessRootVC.pushViewController(targetVC, animated: false)
        
        window.rootViewController = guessRootVC
    }
}


