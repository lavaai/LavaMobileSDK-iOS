//
//  AppSession.swift
//  DemoApp
//

import Foundation

class AppSession {
    
    public static var current: AppSession = AppSession()
    private let KeyEmail = "email"
    private let KeySecureMemberToken = "secure_member_token"
    private let KeyEnableSecureMemberToken = "enable_secure_member_token"
    
    private var userDefaults: UserDefaults? = UserDefaults(suiteName: "demoapp")
    
    var email: String? {
        get {
            return userDefaults?.string(forKey: KeyEmail) ?? nil
        }
        set(newEmail) {
            userDefaults?.set(newEmail, forKey: KeyEmail)
            userDefaults?.synchronize()
        }
    }
    
    var secureMemberToken: String? {
        get {
            return userDefaults?.string(forKey: KeySecureMemberToken) ?? nil
        }
        set(newSecureMemberToken) {
            userDefaults?.set(newSecureMemberToken, forKey: KeySecureMemberToken)
            userDefaults?.synchronize()
        }
    }
    
    var lavaConfig: LavaConfig!
    
    func clear() {
        email = nil
        secureMemberToken = nil
    }
    
}
