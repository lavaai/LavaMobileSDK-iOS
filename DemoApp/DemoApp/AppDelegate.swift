//  AppDelegate.swift
//  DemoApp
//
//  Created by Praveen Castelino on 20/01/16.
//  Copyright © 2016 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK
//import Fabric
//import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    //MARK:- Application callbacks
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Lava.initialize(
            appKey: "test-access-key",
            clientId: "gcp2dev-backend.test"
        )
        
        let customStyle = Style()
            .setTitleFont(UIFont.systemFont(ofSize: 24))
            .setContentFont(UIFont.systemFont(ofSize: 14))
            .setBackgroundColor(UIColor.white)
            .setTitleTextColor(UIColor.black)
            .setContentTextColor(UIColor.darkGray)
        
        Lava.shared.setCustomStyle(customStyle: customStyle)
        
        Lava.debug = true
        
        checkLoggedIn()
        
        registerForPushNotifications()
        
        Lava.shared.start()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    fileprivate func checkLoggedIn() {
        guard let _ = Lava.shared.getLavaUser() else {
            return
        }
        
        guard let navVC = self.window?.rootViewController as? UINavigationController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let targetVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        navVC.pushViewController(targetVC, animated: false)
    }


    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Lava.shared.setNotificationToken(deviceToken: deviceToken)
        
    }

    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Couldn't register: \(error)")
    }
    
    //MARK:- helper methods
    
    func registerForPushNotifications() {
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = 0
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(
            options: [.badge, .sound, .alert],
            completionHandler: { (granted, error) in
                if (granted) {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                } else {
                    //Do stuff if unsuccessful...
                }
            }
        )
    }
    
    //MARK:- Notifications
    
    @objc func lavaUserTokenExpiredNotification(){
        guard let navigationController = self.window?.rootViewController as? UINavigationController else {
            return
        }
        
        navigationController.popToRootViewController(animated: false)
        
        Utility.showAlert(
            navigationController,
            title: "Session expired",
            message: "You have been logged out.",
            leftTitle: "OK",
            rightTitle: nil,
            completionHandler: nil
        )
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        let handled = Lava.shared.handleNotification(userInfo: userInfo)
        
        if handled == false {
            //handle other notifications.
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .badge, .sound])
        
        let userInfo = notification.request.content.userInfo
        
        let handled = Lava.shared.handleNotification(userInfo: userInfo)
        
        if handled == false {
            //handle other notifications.
        }
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        return Lava.shared.handleDeepLink(url: url)
        
    }
    
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL else {
            return false
        }
        
        let handled = Lava.shared.handleDeepLink(url: incomingURL)
        
        if handled == false {
            // Handle other deeplinks by the app itself
        }
        
        return true
    }
    
}


