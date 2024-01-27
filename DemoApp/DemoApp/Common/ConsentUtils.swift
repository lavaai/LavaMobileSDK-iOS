//
//  ConsentUtils.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 26/12/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import Foundation
import LavaSDK

typealias AppConsentMapping = [String: Set<LavaPIConsentFlag>]

struct AppConsent {
    
    static let defaultConsentList: [String] = [
        "Strictly Necessary",
        "Performance And Logging",
        "Functional",
        "Targeting"
    ]
    
    static let customConsentList: [String] = [
        "C0001",
        "C0002",
        "C0003",
        "C0004"
    ]
    
    static let defaultMapping: AppConsentMapping = [
        "Strictly Necessary": [ .strictlyNecessary ],
        "Performance And Logging": [ .performanceAndLogging ],
        "Functional": [ .functional ],
        "Targeting" : [ .targeting ]
    ]
    
    static let customMapping: AppConsentMapping = [
        "C0001": [ .strictlyNecessary ],
        "C0002": [ .performanceAndLogging ],
        "C0003": [ .functional ],
        "C0004" : [ .targeting ]
    ]
    
    static var currentConsentMapping: AppConsentMapping {
        if (AppSession.current.useCustomConsent) {
            return customMapping
        }
        return defaultMapping
    }
    
    static var currentConsentList: [String] {
        if (AppSession.current.useCustomConsent) {
            return customConsentList
        }
        return defaultConsentList
    }
}


class ConsentUtils {
    
    static func getConsentFlags(predefined: [String]?) -> Set<LavaPIConsentFlag>? {
        var consentFlags = AppSession.current.appConsent
        if consentFlags == nil {
            let defaultConsentFlags = predefined ?? Array(AppConsent.currentConsentMapping.keys)
            consentFlags = Set(defaultConsentFlags)
            AppSession.current.appConsent = consentFlags
        }
        
        return toLavaPIConsentFlags(items: consentFlags)
    }
    
    static func getCustomConsentFlags(predefined: [String]?) -> Set<String>? {
        var consentFlags = AppSession.current.appConsent
        if consentFlags == nil {
            let defaultConsentFlags = predefined ?? Array(AppConsent.currentConsentMapping.keys)
            consentFlags = Set(defaultConsentFlags)
            AppSession.current.appConsent = consentFlags
        }
        
        return consentFlags
    }
    
    static func toLavaPIConsentFlags(items: Set<String>?) -> Set<LavaPIConsentFlag>? {
        guard let items = items else {
            return nil
        }
        
        var ret: Set<LavaPIConsentFlag> = []
        items.forEach { item in
            if AppConsent.currentConsentMapping[item] != nil {
                ret = ret.union(AppConsent.currentConsentMapping[item]!)
            }
        }
        
        return ret
    }
    
    static func updateLavaConsent(
        consentFlags: Set<String>,
        callback: @escaping (Error?, Bool) -> Void
    ) {
        
        if (AppSession.current.useCustomConsent) {
            Lava.shared.setCustomPIConsentFlags(
                customPIConsentFlags: consentFlags,
                piConsentCallback: callback
            )
            return
        }
        
        let itemsToUpdate = ConsentUtils.toLavaPIConsentFlags(items: consentFlags) ?? Set()
        Lava.shared.setPIConsentFlags(
            piConsentFlags: itemsToUpdate,
            piConsentCallback: callback
        )
    }
}
