//
//  MultipleLoginViewController.swift
//  DemoApp
//
//  Created by Shabeer on 9/12/18.
//  Copyright © 2018 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK

class MultipleLoginViewController: UIViewController {

    @IBOutlet weak var multipleLoginSwitch: UISwitch!
   
    @IBOutlet weak var currentServerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentServerLabel.text = AppSettings.lavaEnvironment
        if AppSettings.isMultipleLogin {
             multipleLoginSwitch.setOn(true, animated: true)
        }
        else {
             multipleLoginSwitch.setOn(false, animated: true)
        }
   
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLavaEnvironments() {
        
        
        let serverSelectionActionSheetController = UIAlertController(title: "Select environment:", message: nil, preferredStyle: .actionSheet)

        let environmentNames = AppSettingsProvider.getLavaEnvironmentNames()
        
        for environment in environmentNames {
            serverSelectionActionSheetController.addAction(UIAlertAction(title: environment, style: .default, handler: { [weak self](action) in
                guard let weakSelf = self else {
                    return
                }
                AppSettings.lavaEnvironment = action.title
                weakSelf.currentServerLabel.text = AppSettings.lavaEnvironment
                
                if let sdkKeys = AppSettingsProvider.getLavaSDKKeys(environmentName: AppSettings.lavaEnvironment) {
                    Lava.setSDKKeys(sdkKeys)
                } else {
                    weakSelf.view.makeToast("Could not switch to " + AppSettings.lavaEnvironment! + ". SDK keys not found.")
                }

                serverSelectionActionSheetController.dismiss(animated: true, completion: nil)
            }))
            
        }
        self.present(serverSelectionActionSheetController, animated: true, completion: nil)
    }
    
    
    @IBAction func changeServerButton(_ sender: UIButton) {
      showLavaEnvironments()
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        if multipleLoginSwitch.isOn {
            AppSettings.isMultipleLogin = true
    
        } else {
            AppSettings.isMultipleLogin = false
          
        }
     self.dismiss(animated: true, completion: nil)
   
    }


}
