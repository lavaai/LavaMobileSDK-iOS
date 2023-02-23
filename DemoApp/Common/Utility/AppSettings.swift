//
//  AppSettings.swift
//  DemoApp
//
//  Created by Praveen Castelino on 02/04/16.
//

import Foundation

final class AppSettings: NSObject {
    
    class var vendorUUIDString: String? {
        get {
            return self.objectValue(forKey: "app.vendorUUIDString") as? String
        }
        set {
            self.setObjectValue(newValue as NSObject?, forKey: "app.vendorUUIDString")
        }
    }
    
    class var isMultipleLogin: Bool {
        
        get {
            return booleanValue(forKey: "multipleLoginIsOn")
        }
        set {
            self.setBooleanValue(newValue, forKey: "multipleLoginIsOn")
        }
    }
    
    ///LavaSDK environment name.
    class var lavaEnvironment: String? {
        get {
            return self.objectValue(forKey: "app.lavaEnvironment") as? String
        }
        set {
            self.setObjectValue(newValue as NSObject?, forKey: "app.lavaEnvironment")
        }
    }
    
    class var unreadThreads: [String: Int]? {
        get {
            return self.objectValue(forKey: "app.unreadThreads") as? [String: Int]
        }
        set {
            self.setObjectValue(newValue as NSObject?, forKey: "app.unreadThreads")
        }
    }
    
    class var isExpertModeEnabled: Bool {
        get {
            return booleanValue(forKey: "app.isExpertModeEnabled")
        }
        set {
            self.setBooleanValue(newValue, forKey: "app.isExpertModeEnabled")
        }
    }
}


private extension AppSettings
{
    class func booleanValue(forKey key : String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class func setBooleanValue(_ value : Bool, forKey key : String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func integerValue(forKey key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    class func setIntegerValue(_ value: Int, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func objectValue<T : NSObject>(forKey key : String) -> T? {
        return UserDefaults.standard.object(forKey: key) as? T
    }
    
    class func setObjectValue<T : NSObject>(_ object : T?, forKey key : String) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func removeObjectValue(_ key : String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // TODO: Need to conform to NSSecureCoding or NSCoding
    class func setObjectByArchiving<T : NSObject>(_ object : T?, forKey key : String) {
        if let theObject = object {
            guard let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: theObject, requiringSecureCoding: false) else { return }
            self.setObjectValue(archivedData as NSObject?, forKey: key)
        } else {
            self.removeObjectValue(key)
        }
    }
    
    class func objectByUnarchiving<T : NSObject & NSCoding>(forKey key : String) -> T? {
        guard let archivedData = self.objectValue(forKey: key) as? Data else {
            return nil
        }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: archivedData)
    }
}
