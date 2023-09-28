//
//  ConfigLoader.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 19/12/2022.
//  Copyright © 2022 CodeCraft Technologies. All rights reserved.
//

import Foundation

struct LavaConfig: Codable {
    var clientId: String
    var appKey: String
    var enableSecureMemberToken: Bool = false
}

struct TMConfig: Codable {
    var consumerKey: String
    var consumerSecret: String
}

class ConfigLoader {
    
    static func loadLavaConfig() -> LavaConfig? {
        return loadConfig("lava-services")
    }
    
    static func loadTMConfig() -> TMConfig? {
        return loadConfig("tm-services")
    }
    
    static func loadConfig<T: Decodable>(_ configFileName: String) -> T? {
        guard let path = Bundle.main.path(forResource: configFileName, ofType: "json") else {
            fatalError("Cannot load \(configFileName).json")
        }
        
        do {
            var url: URL
            if #available(iOS 16.0, *) {
                url = URL(filePath: path)
            } else {
                url = URL(fileURLWithPath: path)
            }
            
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Cannot parse config: \(error)")
        }
    }
    
}
