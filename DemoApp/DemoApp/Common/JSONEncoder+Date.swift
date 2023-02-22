//
//  JSONEncoder+Date.swift
//  DemoApp
//

import Foundation

extension JSONEncoder {
    static var custom: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
