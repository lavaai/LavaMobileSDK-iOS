//
//  ConsentView.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 26/12/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import SwiftUI
import Combine

struct AppConsentToggle: Identifiable, Equatable {
    var id: AppConsent
    var enabled: Bool
}

struct ConsentView: View {
    
    let dismiss: (() -> Void)?
    @State var appConsentToggles: [AppConsentToggle] = { 
        var enabledSet = AppSession.current.appConsent ?? []
        
        return AppConsent.allCases.map { appConsent in
            AppConsentToggle(id: appConsent, enabled: enabledSet.contains(appConsent))
        }
    }()
    
    @State var hasError: Bool = false
    @State var error: Error? = nil
    
    @State var requireLogout: Bool = false
    
    var isCheckedAll: Bool {
        return appConsentToggles.filter { $0.enabled }.count == AppConsent.allCases.count
    }
    
    func getAppConsentToggles(selected: Set<AppConsent>? = nil) -> [AppConsentToggle] {
        let enabledSet = selected ?? AppSession.current.appConsent ?? []
        
        return AppConsent.allCases.map { appConsent in
            AppConsentToggle(id: appConsent, enabled: enabledSet.contains(appConsent))
        }
    }
    
    func updateConsent(consentList: Set<AppConsent>) {
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
                    Toggle(item.id.title, isOn: $item.enabled)
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
