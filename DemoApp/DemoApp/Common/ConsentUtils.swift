//
//  ConsentUtils.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 26/12/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import Foundation
import LavaSDK

enum AppConsent: String, Codable, CaseIterable {
    case strictlyNecessary = "StrictlyNecessary"
    case performanceAndLogging = "PerformanceAndLogging"
    case functional = "Functional"
    case targeting = "Targeting"
    
    func toLavaPIConsentFlag() -> LavaPIConsentFlag {
        // Must not crash
        return LavaPIConsentFlag(rawValue: rawValue)!
    }
    
    var title: String {
        switch self {
        case .functional:
            return "Functional"
        case .performanceAndLogging:
            return "Performance And Logging"
        case .strictlyNecessary:
            return "Strictly Necessary"
        case .targeting:
            return "Targeting"
        }
    }
    
    
}

class ConsentUtils {
    
    static func getConsentFlags(predefined: [String]?) -> Set<LavaPIConsentFlag>? {
        var consentFlags = AppSession.current.appConsent
        if consentFlags == nil {
            let defaultConsentFlags = predefined ?? AppConsent.allCases.map { $0.rawValue }
            consentFlags = Set(defaultConsentFlags.map { AppConsent(rawValue: $0)! })
            AppSession.current.appConsent = consentFlags
        }
        
        return toLavaPIConsentFlags(items: consentFlags!)
    }
    
    static func toLavaPIConsentFlags(items: Set<AppConsent>?) -> Set<LavaPIConsentFlag>? {
        guard let items = items else {
            return nil
        }
        return Set(items.map { $0.toLavaPIConsentFlag() })
    }
    
    static func updateLavaConsent(consentFlags: Set<AppConsent>, callback: @escaping (Error?, Bool) -> Void) {
        let itemsToUpdate = ConsentUtils.toLavaPIConsentFlags(items: consentFlags) ?? Set()
        return  Lava.shared.setPIConsentFlags(
            piConsentFlags: itemsToUpdate,
            piConsentCallback: callback
        )
    }
}
