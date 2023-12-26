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
    case strictlyNecessary = "Strictly Necessary"
    case performanceAndLogging = "Performance And Logging"
    case functional = "Functional"
    case targeting = "Targeting"
    
    func toLavaPIConsentFlag() -> LavaPIConsentFlag {
        switch self {
        case .functional:
            return .functional
        case .performanceAndLogging:
            return .performanceAndLogging
        case .strictlyNecessary:
            return .strictlyNecessary
        case .targeting:
            return .targeting
        }
    }
    
    static func toLavaPIConsentFlags(items: Set<AppConsent>?) -> Set<LavaPIConsentFlag>? {
        guard let items = items else {
            return nil
        }
        return Set(items.map { $0.toLavaPIConsentFlag() })
    }
}

class ConsentUtils {
    static func updateLavaConsent() {
        let itemsToUpdate = AppConsent.toLavaPIConsentFlags(items: AppSession.current.appConsent) ?? Set()
        Lava.shared.setPIConsentFlags(piConsentFlags: itemsToUpdate)
    }
}
