//
//  ButtonStyles.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 15/10/25.
//  Copyright © 2025 LAVA. All rights reserved.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .foregroundColor(.white)
            .background(AppColor.primary.toColor())
            .clipShape(Capsule())
    }
}
