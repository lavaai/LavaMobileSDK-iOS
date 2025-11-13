//
//  SignInViewController.swift
//  DemoApp1
//
//  Created by rohith on 21/01/16.
//

import UIKit
import LavaSDK

class SignInViewController: EditableViewController {
    let ExternalSystemEmail = 0
    let ExternalSystemExternalUserID = 1
    
    
    @IBOutlet weak var vLoginForm: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var aiAnonymousLogin: UIActivityIndicatorView!
    @IBOutlet weak var lbAnonymousStatus: UILabel!
    @IBOutlet weak var lbAnonymousError: UILabel!
    @IBOutlet weak var scExternalSystem: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginAnonymous()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func loginAnonymous() {
        lbAnonymousError.isHidden = true
        lbAnonymousStatus.isHidden = true
        aiAnonymousLogin.isHidden = false
        aiAnonymousLogin.startAnimating()
        Lava.shared.setEmail(email: nil) { [weak self] in
            self?.aiAnonymousLogin.isHidden = true
            self?.lbAnonymousError.isHidden = true
            self?.lbAnonymousStatus.isHidden = false
        } onError: { [weak self] err in
            self?.aiAnonymousLogin.isHidden = true
            self?.lbAnonymousError.isHidden = false
            self?.lbAnonymousStatus.isHidden = true
        }

    }

    // MARK: - UITextfieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    func goToHome() {
        Navigator.shared.goToToMain()
    }
    
    // MARK: - Action methods
    
    @IBAction func signInAction(_ sender: Any) {
        view.endEditing(true)

        // Perform login
        login(email: tfEmail.text)
    }
    
    @IBAction func onChangeExternalSystem(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case ExternalSystemEmail:
            tfEmail.text = "app.001@lava.ai"
            break
        case ExternalSystemExternalUserID:
            tfEmail.text = "123123123"
            break
        default:
            break
        }
    }
    
    
    @IBAction func showPass(_ sender: Any) {
        Lava.shared.showPass()
    }
    
    
    @IBAction func showInitializeOptions(_ sender: Any) {
        Navigator.shared.openInitializeOptions(self)
    }
    
    @IBAction func showConsentPreferences(_ sender: Any) {
        Navigator.shared.openConsentPreferences(self)
    }
    
    func login(email: String?) {
        if AppSession.current.lavaConfig.enableSecureMemberToken {
            loginWithAppBackend(email: email)
        } else {
            loginWithSdk(email: email)
        }
    }
    
    @IBAction func showInbox(_ sender: Any) {
        Lava.shared.showInboxMessages(self)
    }
    
    @IBAction func showDebugInfo(_ sender: Any) {
        Navigator.shared.openDebugSheet(self)
    }
    
    func loginWithAppBackend(email: String?) {
        guard let email = email else {
            return
        }
        
        view.showLoading(ToastPosition.center)
        
        RESTClient.shared.login(username: email, successCallback: { authResponse in
                    
            Lava.shared.setEmail(email: email) { [weak self] in
                let event = TrackEvent(
                    category: "DEBUG",
                    path: "Successfully login",
                    trackerType: "log"
                )
                
                Lava.shared.track(event: event)
                
                AppSession.current.email = email
                
                self?.view.hideLoading()
                self?.goToHome()
                
                
                guard let memberToken = authResponse.memberToken else {
                    fatalError("Empty auth token")
                }
                
                AppSession.current.secureMemberToken = memberToken
                Lava.shared.setSecureMemberToken(memberToken)
            } onError: { [weak self] error in
                self?.view.hideLoading()
                self?.showAlert(title: "Error", message: "\(error)")
            }
        }, errorCallback: { [weak self] error in
            self?.view.hideLoading()
            self?.showAlert(title: "Error", message: "\(error)")
        })
    }
    
    func loginWithSdk(email: String?) {
        view.showLoading(ToastPosition.center)
        
        Lava.shared.setSecureMemberToken(nil)
        
        if (scExternalSystem.selectedSegmentIndex == ExternalSystemEmail) {
            Lava.shared.setEmail(email: email) { [weak self] in
                let event = TrackEvent(
                    category: "DEBUG",
                    path: "Successfully login",
                    trackerType: "log"
                )
                
                Lava.shared.track(event: event)
                
                AppSession.current.email = email
                
                self?.view.hideLoading()
                self?.goToHome()
            } onError: { [weak self] error in
                self?.view.hideLoading()
                self?.showAlert(title: "Error", message: "\(error)")
            }
            
            return
        }
        
        Lava.shared.setUserId(
            id: email,
            type: "nba_id_encrypted"
        ) { [weak self] in
            let event = TrackEvent(
                category: "DEBUG",
                path: "Successfully login",
                trackerType: "log"
            )
            
            Lava.shared.track(event: event)
            
            AppSession.current.email = email
            
            self?.view.hideLoading()
            self?.goToHome()
        } onError: { [weak self] error in
            self?.view.hideLoading()
            self?.showAlert(title: "Error", message: "\(error.localizedDescription)")
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
