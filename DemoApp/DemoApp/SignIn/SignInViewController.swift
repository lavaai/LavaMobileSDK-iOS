//
//  SignInViewController.swift
//  DemoApp1
//
//  Created by rohith on 21/01/16.
//

import UIKit
import LavaSDK

class SignInViewController: EditableViewController {
    
    @IBOutlet weak var vLoginForm: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
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
        login(email: tfEmail.text, password: tfPassword.text)
    }
    
    func login(email: String?, password: String?) {
        if AppSession.current.lavaConfig.enableSecureMemberToken {
            loginWithAppBackend(email: email, password: password)
        } else {
            loginWithSdk(email: email)
        }
    }
    
    func loginWithAppBackend(email: String?, password: String?) {
        guard let email = email, let password = password else {
            return
        }
        
        view.showLoading(ToastPosition.center)
        
        RESTClient.shared.login(username: email, password: password, successCallback: { authResponse in
                    
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
        Lava.shared.setSecureMemberToken(nil)
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
