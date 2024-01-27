//
//  Navigator.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 12/09/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import UIKit
import SwiftUI
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
    
    func openDebugSheet(_ vc: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "DebugInfoViewController")
        vc.present(targetVC, animated: true)
    }
    
    func openAnalytics(_ nc: UINavigationController) {
        let targetVC = UIHostingController(
            rootView: AnalyticsView()
        )
        targetVC.setupMenu()
        nc.viewControllers = [
            targetVC
        ]
    }
    
    func openConsentPreferences(_ vc: UIViewController) {
        let dismissAction = {
            guard let targetVC = vc.presentedViewController else {
                return
            }
            targetVC.dismiss(animated: true)
            vc.viewWillAppear(true)
        }
        let targetVC = UIHostingController(
            rootView: ConsentView(dismiss: dismissAction)
        )
        vc.present(targetVC, animated: true)
    }
}


