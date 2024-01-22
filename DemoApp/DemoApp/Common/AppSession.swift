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
    private let KeyAppConsent = "app_consent"
    private let KeyUseCustomConsent = "use_custom_consent"
    
    private var userDefaults: UserDefaults? = UserDefaults(suiteName: "sdkdemoapp")
    
    var email: String? {
        get {
            return userDefaults?.string(forKey: KeyEmail) ?? nil
        }
        set(newEmail) {
            userDefaults?.set(newEmail, forKey: KeyEmail)
        }
    }
    
    var secureMemberToken: String? {
        get {
            return userDefaults?.string(forKey: KeySecureMemberToken) ?? nil
        }
        set(newSecureMemberToken) {
            userDefaults?.set(newSecureMemberToken, forKey: KeySecureMemberToken)
        }
    }
    
    var appConsent: Set<String>? {
        get {
            guard let raw = userDefaults?.value(forKey: KeyAppConsent) as? Data else {
                return nil
            }
            guard let ret = try? JSONDecoder().decode(Set<String>.self, from: raw) else {
                return nil
            }
            return ret
        }
        
        set(value) {
            guard let encoded = try? JSONEncoder().encode(value) else {
                return
            }
            userDefaults?.set(encoded, forKey: KeyAppConsent)
        }
    }
    
    var useCustomConsent: Bool {
        get {
            return userDefaults?.bool(forKey: KeyUseCustomConsent) ?? false
        }
        
        set(value) {
            userDefaults?.set(value, forKey: KeyUseCustomConsent)
        }
    }
    
    var lavaConfig: LavaConfig!
    
    func clear() {
        email = nil
        secureMemberToken = nil
        userDefaults?.removeSuite(named: "sdkdemoapp")
    }
    
}
