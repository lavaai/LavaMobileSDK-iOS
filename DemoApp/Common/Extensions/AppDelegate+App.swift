//
//  AppDelegate+App.swift
//  DemoApp
//
//  Created by srinath on 21/09/16.
//

import Foundation
import UIKit

extension AppDelegate {
    
    class func getRootViewController() -> UINavigationController? {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let viewController = appDelegate.window?.rootViewController as? UINavigationController
        return viewController
    }
    
    class func getAppDelegate() -> AppDelegate {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }
    
}
