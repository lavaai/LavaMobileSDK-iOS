//
//  InitializeOptionsView.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 15/10/25.
//  Copyright © 2025 LAVA. All rights reserved.
//

import SwiftUI
import LavaSDK
import Combine

struct InitializeOptionsView: View {
    
    let dismiss: (() -> Void)?
    
    @State var hasError: Bool = false
    @State var error: Error? = nil
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button {
                    dismiss?()
                } label: {
                    Image(systemName: "arrow.backward")
                }
                .foregroundColor(.black)
                .frame(width: 60, height: 60)
                
                Text(
                    "Initialize Options"
                )
                .font(.system(size: 18, weight: .bold))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 60))
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                Button {
                    AppDelegate.shared?.initLavaSDKWithDefaultConfig()
                    dismiss?()
                } label: {
                    Text("Init with default config")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button {
                    AppDelegate.shared?.initLavaSDKWithDefaultConsent()
                    dismiss?()
                } label: {
                    Text("Init with default consent")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
                
                
                Button {
                    AppDelegate.shared?.initLavaSDKWithCustomConsentMapping()
                    dismiss?()
                } label: {
                    Text("Init with custom consent")
                        .frame(maxWidth: .infinity)
                        
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button {
                    AppDelegate.shared?.initLavaSDKWithInvalidConfig()
                    dismiss?()
                } label: {
                    Text("Init with invalid config")
                        .frame(maxWidth: .infinity)
                        
                }
                .buttonStyle(PrimaryButtonStyle())
                
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .alert(isPresented: $hasError, content: {
            Alert(
                title: Text("Consent Error"),
                message: Text(error?.localizedDescription ?? "Unknown consent error"),
                dismissButton: .default(Text("Close"))
            )
        })
        
        
    }
}

struct InitializeOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        InitializeOptionsView(dismiss: nil)
    }
}
