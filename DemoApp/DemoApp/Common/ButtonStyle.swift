//
//  ButtonStyle.swift
//  DemoApp
//
//  Copyright © 2024 LAVA. All rights reserved.
//

import SwiftUI

struct AppButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(AppColor.primary.toColor())
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}
