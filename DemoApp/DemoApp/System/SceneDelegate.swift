//
//  SceneDelegate.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 11/09/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import UIKit
import LavaSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let window = window {
            Navigator.initialize(window)
            Navigator.shared.goToStartUpScreen()
        } else {
            print("window is nil")
        }
        
        if let urlContext = connectionOptions.urlContexts.first {
            handleDeeplink(url: urlContext.url)
        }
        
        if let userActivity = connectionOptions.userActivities.first,
           userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL {
            handleDeeplink(url: url)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleDeeplink(url: url)
    }
        
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return }
        handleDeeplink(url: url)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if AppDelegate.shared?.userInfoToRender != nil {
            _ = Lava.shared.handleNotification(userInfo: AppDelegate.shared!.userInfoToRender!)
            AppDelegate.shared!.userInfoToRender = nil
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

    
    func handleDeeplink(url: URL?) {
        guard let url = url else {
            return
        }
        
        if (Lava.shared.canHandleDeepLink(url: url)) {
            _ = Lava.shared.handleDeepLink(url: url) { err in
                print(err.localizedDescription)
            }
        } else {
            // handle other deep links
            return
        }
    }

}
