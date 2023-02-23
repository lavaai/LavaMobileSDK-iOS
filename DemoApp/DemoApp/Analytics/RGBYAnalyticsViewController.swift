//
//  RGBYAnalyticsViewController.swift
//  DemoApp
//
//  Created by srinath on 10/06/16.
//  Copyright © 2016 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK

let AnalyticsNotEnabledError = "Analytics not enabled. Go to Settings to enable this."

class RGBYAnalyticsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ToastManager.shared.duration = 0.1
        ToastManager.shared.queueEnabled = false
        Lava.tracker.trackEvent(category: "RGBYAnalyticsScreen", action: .viewScreen)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ToastManager.shared.duration = 3.0
        ToastManager.shared.queueEnabled = true
    }
    
    @IBAction func RedButtonTapAction(_ sender: UIButton) {
        guard Lava.tracker.enabled else {
            view.makeToast(AnalyticsNotEnabledError)
            return
        }
        Lava.tracker.trackEvent(category: "sequence red", action: .click, tags: ["red"])
        view.makeToast("Analytics data sent for red")
    }
    
    @IBAction func GreenButtonTapAction(_ sender: UIButton) {
        guard Lava.tracker.enabled else {
            view.makeToast(AnalyticsNotEnabledError)
            return
        }
        Lava.tracker.trackEvent(category: "sequence green", action: .click, tags: ["green"])

        view.makeToast("Analytics data sent for green")
    }
    
    @IBAction func BlueButtonTapAction(_ sender: UIButton) {
        guard Lava.tracker.enabled else {
            view.makeToast(AnalyticsNotEnabledError)
            return
        }
        Lava.tracker.trackEvent(category: "sequence blue", action: .click, tags: ["blue"])
        view.makeToast("Analytics data sent for blue")
    }
    
    @IBAction func YellowButtonTapAction(_ sender: UIButton) {
        guard Lava.tracker.enabled else {
            view.makeToast(AnalyticsNotEnabledError)
            return
        }
        Lava.tracker.trackEvent(category: "sequence yellow", action: .click, tags: ["yellow"])
        view.makeToast("Analytics data sent for yellow")
    }
    
}
