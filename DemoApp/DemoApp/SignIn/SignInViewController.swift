//
//  SignInViewController.swift
//  DemoApp1
//
//  Created by rohith on 21/01/16.
//  Copyright © 2016 codecraft. All rights reserved.
//

import UIKit
import LavaSDK

class SignInViewController: EditableViewController {
    
    
    @IBOutlet weak var vLoginForm: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - UITextfieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    func showProfileViewController() {
        let profilePageViewCntrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

        if let _ = navigationController {
            self.navigationController!.pushViewController(profilePageViewCntrl, animated: false)
        }
    }
    
    func goToHome() {
        guard let navigationController = navigationController else { return }
        
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: nil
        )
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    // MARK: - Action methods
    
    @IBAction func signInAction(_ sender: Any) {
        view.endEditing(true)

        // Perform login
        login(email: tfEmail.text)
    }
    
    func login(email: String?) {
        
        view.showLoading(ToastPosition.center)
        
        Lava.shared.setEmail(email: email) { [weak self] in
            
            let event = TrackEvent(
                category: "DEBUG",
                path: "Successfully login",
                trackerType: "log"
            )
            
            Lava.shared.track(event: event)
            
            self?.view.hideLoading()
            self?.goToHome()
        } onError: { [weak self] error in
            self?.view.hideLoading()
            self?.showAlert(title: "Error", message: (error as! APIError).description)
        }
        
    }

    
    //MARK: - Helper Methods
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func clearAllTextFields() {
        tfEmail.text = ""
    }
    
    func handleError(error: Error) {
        Utility.showAlert(
            self,
            title: "Error",
            message: error.localizedDescription,
            leftTitle: "OK",
            rightTitle: nil,
            completionHandler: nil
        )
    }
    
    override func getEditableView() -> UIView? {
        return vLoginForm
    }
    
    
}
