//
//  String+JSON.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 19/12/2022.
//  Copyright © 2022 CodeCraft Technologies. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    
    func toObject<T: Decodable>() -> T? {
        guard let data = self?.data(using: .utf8) else {
            print("Cannot convert to data")
            return nil
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error decoding object: \(error)")
        }
        return nil
    }
    
}
