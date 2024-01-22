//
//  ConsentView.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 26/12/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import SwiftUI
import LavaSDK
import Combine

struct AppConsentToggle: Identifiable, Equatable {
    var id: String
    var enabled: Bool
}

struct ConsentView: View {
    
    let dismiss: (() -> Void)?
    @State var appConsentToggles: [AppConsentToggle] = { 
        var enabledSet = AppSession.current.appConsent ?? []
        
        return AppConsent.currentConsentList.map { appConsent in
            AppConsentToggle(id: appConsent, enabled: enabledSet.contains(appConsent))
        }
    }()
    
    @State var hasError: Bool = false
    @State var error: Error? = nil
    
    @State var requireLogout: Bool = false
    @State var useCustomConsent: Bool = AppSession.current.useCustomConsent
    
    var isCheckedAll: Bool {
        return appConsentToggles.filter { $0.enabled }.count == AppConsent.currentConsentMapping.keys.count
    }
    
    func getAppConsentToggles(selected: Set<String>? = nil) -> [AppConsentToggle] {
        let enabledSet = selected ?? AppSession.current.appConsent ?? []
        
        return AppConsent.currentConsentList.map { appConsent in
            AppConsentToggle(id: appConsent, enabled: enabledSet.contains(appConsent))
        }
    }
    
    func updateConsent(consentList: Set<String>) {
        var storedConsentList = AppSession.current.appConsent ?? Set()
        if (storedConsentList.isSuperset(of: consentList)) {
            storedConsentList = storedConsentList.subtracting(consentList)
        } else {
            storedConsentList = storedConsentList.union(consentList)
        }
        
        appConsentToggles = getAppConsentToggles(selected: storedConsentList)
        
        ConsentUtils.updateLavaConsent(consentFlags: storedConsentList) { err, shouldLogout in
            if err != nil {
                appConsentToggles = getAppConsentToggles()
                hasError = true
                error = err
                return
            }
            AppSession.current.appConsent = storedConsentList
            appConsentToggles = getAppConsentToggles()
            
            if (shouldLogout) {
                requireLogout = shouldLogout
            }
        }
    }
    
    func toggleCustomConsent() {
        let storedConsentList = AppSession.current.appConsent ?? Set()
        let lavaConsentList = ConsentUtils.toLavaPIConsentFlags(items: storedConsentList)
        
        let shouldUseCustomConsent = !AppSession.current.useCustomConsent
        useCustomConsent = shouldUseCustomConsent
        
        // Reinit the SDK
        AppDelegate.shared?.initLavaSdk(useCustomConsentMapping: useCustomConsent)
        
        var newConsentList: Set<String> = []
        for (key, value) in AppConsent.currentConsentMapping {
            if (lavaConsentList?.isSuperset(of: value) ?? false) {
                newConsentList.insert(key)
            }
        }
        
        AppSession.current.appConsent = newConsentList
                                                 
        appConsentToggles = getAppConsentToggles(selected: newConsentList)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button {
                    dismiss?()
                    if requireLogout {
                        Navigator.shared.goToSignIn()
                    }
                } label: {
                    Image(systemName: "arrow.backward")
                }
                .foregroundColor(.black)
                .frame(width: 60, height: 60)
                
                Text(
                    "Consent Preferences"
                )
                .font(.system(size: 18, weight: .bold))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 60))
                .frame(maxWidth: .infinity)
            }
            
            Form {
                ForEach($appConsentToggles) { $item in
                    Toggle(isOn: $item.enabled) {
                        Text(item.id)
                            .font(.system(size: 18, weight: .bold))
                        Text(AppConsent.currentConsentMapping[item.id]?.map { $0.rawValue }.joined(separator: ", ") ?? "N/A")
                    }
                    .onChange(of: item.enabled) { isOn in
                        updateConsent(consentList: Set([item.id]))
                    }
                }
                
                Section {
                    Button {
                        let checked = !isCheckedAll
                        if (checked) {
                            appConsentToggles[0].enabled = checked
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                for index in 1..<appConsentToggles.count {
                                    appConsentToggles[index].enabled = checked
                                }
                            }
                        }
                        
                        if (!checked) {
                            for index in 1..<appConsentToggles.count {
                                appConsentToggles[index].enabled = checked
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                appConsentToggles[0].enabled = checked
                            }
                        }
                    } label: {
                        Text(isCheckedAll ? "Uncheck All" : "Check All")
                            .foregroundColor(.red)
                    }
                    
                    Button {
                        toggleCustomConsent()
                    } label: {
                        Text(!useCustomConsent ? "Use Custom consents" : "Use LAVA default consents")
                            .foregroundColor(.blue)
                    }
                }
            }
            
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

struct ConsentView_Previews: PreviewProvider {
    static var previews: some View {
        ConsentView(dismiss: nil)
    }
}
