//
//  Color.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 13/09/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import UIKit

class Color {
    static let primary: UIColor = fromHex(hex: "#581AA6")
    static let secondary: UIColor = fromHex(hex: "#D72ADB")
    static let white: UIColor = .white
    static let black: UIColor = .black
    static let lightGrey: UIColor = fromHex(hex: "#F9F9F9")
    static let darkGrey: UIColor = fromHex(hex: "#3D2854")
    
    static func fromHex(hex: String) -> UIColor {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        return UIColor(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            alpha: Double(a) / 255
        )
    }
}
