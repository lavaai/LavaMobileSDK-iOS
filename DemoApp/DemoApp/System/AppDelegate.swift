//  AppDelegate.swift
//  DemoApp
//
//  Created by Praveen Castelino on 20/01/16.
//

import UIKit
import LavaSDK
//import Fabric
//import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    static var shared: AppDelegate? = nil

    var window: UIWindow?
    
    func initLavaSdk(
        useCustomConsentMapping: Bool = false
    ) {
        
        guard let lavaConfig = ConfigLoader.loadConfig() else {
            fatalError("Error loading lava-services.json")
        }
        
        // Initialise LavaSDK.
        if useCustomConsentMapping {
            Lava.initialize(
                appKey: lavaConfig.appKey,
                clientId: lavaConfig.clientId,
                logLevel: .verbose,
                serverLogLevel: .verbose,
                customPiConsentMapping: LavaConsent.OneTrustDefaultConsentMapping,
                customPiConsentFlags: ConsentUtils.getCustomConsentFlags(predefined: lavaConfig.customConsentFlags),
                piConsentCallback: { err, shouldLogout in
                    print(err?.localizedDescription ?? "Unknown consent error")
                }
            )
        } else {
            Lava.initialize(
                appKey: lavaConfig.appKey,
                clientId: lavaConfig.clientId,
                logLevel: .verbose,
                serverLogLevel: .verbose,
                piConsentFlags: ConsentUtils.getConsentFlags(predefined: lavaConfig.consentFlags),
                piConsentCallback: { err, shouldLogout in
                    print(err?.localizedDescription ?? "Unknown consent error")
                }
            )
        }
        
        AppSession.current.useCustomConsent = useCustomConsentMapping
        
        let customStyle = Style()
            .setTitleFont(UIFont.systemFont(ofSize: 24))
            .setContentFont(UIFont.systemFont(ofSize: 14))
            .setBackgroundColor(UIColor.white)
            .setTitleTextColor(UIColor.black)
            .setContentTextColor(UIColor.darkGray)
        
        Lava.shared.setCustomStyle(customStyle: customStyle)
        
        Lava.shared.start()
        
        if (lavaConfig.enableSecureMemberToken) {
            Lava.shared.subscribeSecureMemberTokenExpiry(self)
        } else {
            Lava.shared.setSecureMemberToken(nil)
            Lava.shared.unsubscribeSecureMemberTokenExpiry(self)
        }
        
        AppSession.current.lavaConfig = lavaConfig
    }
    
    //MARK:- Application callbacks
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //initialise LavaSDK.
        initLavaSdk(
            useCustomConsentMapping: AppSession.current.useCustomConsent
        )
        
        registerForPushNotifications()
        
        if let secureMemberToken = AppSession.current.secureMemberToken {
            Lava.shared.setSecureMemberToken(secureMemberToken)
        }
        
        AppDelegate.shared = self
                
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
        Lava.shared.unsubscribeSecureMemberTokenExpiry(self)
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
        
        if (Lava.shared.canHandlePushNotification(userInfo: userInfo)) {
            let handled = Lava.shared.handleNotification(userInfo: userInfo)
            if (!handled) {
                // handling lava notification failed
            }
        } else {
            // handle other notifications.
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .badge, .sound])
        
        let userInfo = notification.request.content.userInfo

        if (Lava.shared.canHandlePushNotification(userInfo: userInfo)) {
            let handled = Lava.shared.handleNotification(userInfo: userInfo)
            if !handled {
                // handling lava notification failed
            }
        } else {
            //handle other notifications.
        }
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if (Lava.shared.canHandleDeepLink(url: url)) {
            return Lava.shared.handleDeepLink(url: url)
        } else {
            // handle other deep links
            return false
        }
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

extension AppDelegate: TokenExpiryDelegate {
    
    func onExpire(onSuccess: @escaping OnSuccess, onError: @escaping OnError) {
        // RESTClient.shared.refreshToken is an example of API call to App Backend in Mobile App
        guard let email = AppSession.current.email else {
            print("No email provided")
            return
        }
        
        RESTClient.shared.refreshToken(username: email, successCallback: { authResponse in
            guard let memberToken = authResponse.memberToken else {
                onError(APIError.emptyData)
                return
            }
            Lava.shared.setSecureMemberToken(memberToken)
            onSuccess()
        }, errorCallback: { error in
            onError(error)
        })
    }
    
}




