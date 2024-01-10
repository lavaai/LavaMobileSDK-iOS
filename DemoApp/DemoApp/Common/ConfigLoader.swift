//
//  ConfigLoader.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 19/12/2022.
//  Copyright © 2022 LAVA. All rights reserved.
//

import Foundation

struct LavaConfig: Codable {
    var clientId: String
    var appKey: String
    var enableSecureMemberToken: Bool = false
    var consentFlags: [String]
}

class ConfigLoader {
    
    static func loadConfig() -> LavaConfig? {
        guard let path = Bundle.main.path(forResource: "lava-services", ofType: "json") else {
            fatalError("Cannot load lava-services.json")
        }
        
        do {
            var url: URL
            if #available(iOS 16.0, *) {
                url = URL(filePath: path)
            } else {
                url = URL(fileURLWithPath: path)
            }
            
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            
            return try JSONDecoder().decode(LavaConfig.self, from: data)
        } catch {
            fatalError("Cannot parse config: \(error)")
        }
    }
    
}
