//
//  Codable+JSON.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 19/12/2022.
//  Copyright © 2022 CodeCraft Technologies. All rights reserved.
//

import Foundation

extension Encodable {
    
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            print("Cannot encode Encodable")
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
