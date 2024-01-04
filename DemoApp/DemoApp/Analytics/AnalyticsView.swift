//
//  AnalyticsView.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 02/01/2024.
//  Copyright © 2024 LAVA. All rights reserved.
//

import SwiftUI
import LavaSDK
import AlertToast

struct AnalyticsView: View {
    
    @State private var showResult = false
    
    func trackButton(
        trackCategory: String,
        buttonLabel: String,
        icon: String
    ) -> some View {
        return Button(
            action: {
                let trackEvent = TrackEvent(
                    action: "Interaction",
                    category: trackCategory
                )
                
                Lava.shared.track(event: trackEvent)
                showResult.toggle()
            }, label: {
                HStack {
                    Image(systemName: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: 30,
                            height: 30
                        )
                    Text(buttonLabel)
                }
                .frame(
                    maxWidth: .infinity
                )
            }
        )
        .buttonStyle(AppButtonStyle())
    }
    
    var body: some View {
        VStack {
            trackButton(trackCategory: "Video 1", buttonLabel: "View Video 1", icon: "video.circle.fill")
            trackButton(trackCategory: "Video 2", buttonLabel: "View Video 2", icon: "video.circle.fill")
            
            trackButton(trackCategory: "Image 1", buttonLabel: "View Image 1", icon: "photo.circle.fill")
            trackButton(trackCategory: "Image 2", buttonLabel: "View Image 2", icon: "photo.circle.fill")
            
            trackButton(trackCategory: "Article 1", buttonLabel: "View Article 1", icon: "newspaper.circle.fill")
            trackButton(trackCategory: "Article 2", buttonLabel: "View Article 2", icon: "newspaper.circle.fill")
            
            Spacer()
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .navigationTitle("Analytics")
        .toast(isPresenting: $showResult) {
            AlertToast(type: .regular, title: "Track event submitted")
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
