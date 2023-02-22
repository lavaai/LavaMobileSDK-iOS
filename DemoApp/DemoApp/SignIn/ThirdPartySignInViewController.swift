//
//  ThirdPartySignInViewController.swift
//  DemoApp
//
//  Created by sharath on 07/07/16.
//  Copyright © 2016 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK

class ThirdPartySignInViewController: UIViewController {
    
    @IBOutlet weak var systemTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forceSignInButton: UIButton!
    @IBOutlet weak var viewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerView: UIView!
    
    var singleTap : UITapGestureRecognizer?
    var selectedSignUpType : SignUpTypes?
    var externalSystemActionSheetController: UIAlertController?
//    var isMultipleLoginEnabled: Bool {
//        if AppSettings.isMultipleLogin {
//           return true
//        } else {
//            return false
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Lava.tracker.trackEvent(category: "ThirdPartyLogin", action: .viewScreen)
        super.viewWillAppear(animated)
        clearAllTextFields()
        singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        singleTap?.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTap!)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        viewCenterYConstraint.constant = 0.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.removeGestureRecognizer(singleTap!)
        NotificationCenter.default.removeObserver(self)
        view.endEditing(true)
    }
    
    //MARK:- Keyboard Notifications
    
    @objc func keyboardDidShow(notification : NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            if keyboardEndFrame!.isNull {
                return
            }
            let maxY: CGFloat = self.registerView.frame.maxY
            let totalHeight: CGFloat = self.view.frame.height
            let diff: CGFloat = totalHeight - maxY
            let keyBoardHeight : CGFloat = keyboardEndFrame!.height
            if diff < keyBoardHeight {
                if notification.name == UIResponder.keyboardDidShowNotification {
                    let constraintPos: CGFloat = keyBoardHeight - diff
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.viewCenterYConstraint.constant -= constraintPos
                        self.view.layoutIfNeeded()
                        }, completion: nil)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification : NSNotification) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.viewCenterYConstraint.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    //MARK:- Private methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        systemTextField.resignFirstResponder()
        userIdTextField.resignFirstResponder()
        return true
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func clearAllTextFields() {
        systemTextField.text = ""
        userIdTextField.text = ""
    }
    
    func showSignInViewController() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- Action methods
    
    @IBAction func signInAction(_ sender: Any) {
        signIn(forceLogin: false)
    }
    
    @IBAction func forceSignInAction(_ sender: Any) {
        signIn(forceLogin: true)
    }
    
    func signIn(forceLogin: Bool) {
        view.endEditing(true)
        if let system = systemTextField.text ,let userId = userIdTextField.text, system != "" && userId != "" {
            signInButton.isUserInteractionEnabled = false
            forceSignInButton.isUserInteractionEnabled = false
            self.view.makeToastActivity(.center)
            Lava.signInWithExternalSystem(systemName: system, userId: userId, forceLogin: forceLogin, completion: { [weak self](user, error) -> Void in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.view.hideToastActivity()
                weakSelf.signInButton.isUserInteractionEnabled = true
                weakSelf.forceSignInButton.isUserInteractionEnabled = true
                if error == nil {
                    if user != nil {
                        if AppSettings.isMultipleLogin == false {
                        weakSelf.view.makeToast("Success", duration: 0.2, position:CGPoint(x: weakSelf.view.frame.width/2, y: weakSelf.view.frame.height/2))
                        weakSelf.selectedSignUpType = SignUpTypes.thirdParty
                        weakSelf.showProfilePageViewController(signInType: self?.selectedSignUpType)
                        } else {
                            if let externalSystem = user?.accounts?.first?.externalSystem, let userId = user?.accounts?.first?.externalId {
                                self?.view.makeToast("external system: \(externalSystem) userid: \(userId)", duration: 3, position: .center) }
                        }
                        }
                } else {
                    if let l_error = error {
                        if let theUser = user, error?.code == LavaErrorCode.userAlreadyLoggedIn.rawValue {
                            //user already logged in using other device. Ask user if he wants to continue with login.
                            Utility.displayAlertWith(weakSelf, title: "", message: error!.localizedDescription, leftTitle: "Cancel", rightTitle: "Continue", completionHandler: {(alertaction) -> Void in
                                if alertaction?.title == "Continue" {
                                    //Use user object in sign-in response to make continue-sign-in.
                                    weakSelf.selectedSignUpType = SignUpTypes.thirdParty
                                    weakSelf.continueSignInWithUser(user: theUser)
                                }
                            })
                        } else {
                            //other errors
                            Utility.displayAlertWith(weakSelf, title: "Failure", message: l_error.localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                        }
                    }
                }
            })

        } else {
            Utility.displayAlertWith(self, title: "Failure", message: "Incomplete information.", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
        }
    }
    
    private func continueSignInWithUser(user: LavaUser) {
        self.view.makeToastActivity(.center)
        Lava.continueSignInWithUser(user: user, completion: { [weak self] (user, error) -> Void in
            guard let weakSelf = self else {
                return
            }
            weakSelf.view.hideToastActivity()
            weakSelf.signInButton.isUserInteractionEnabled = true
            weakSelf.forceSignInButton.isUserInteractionEnabled = true
            
            if let theError = error {
                Utility.displayAlertWith(weakSelf, title:"Failure", message: theError.localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: nil)
            } else {
                //success. get into the app.
                weakSelf.showProfilePageViewController(signInType: weakSelf.selectedSignUpType)
            }
            })
    }
    
    func showActionController() {
        if externalSystemActionSheetController == nil {
            externalSystemActionSheetController = UIAlertController(title: "Select an external system", message: nil, preferredStyle: .actionSheet)
            
            externalSystemActionSheetController?.addAction(UIAlertAction(title: "system1", style: .default, handler: { [weak self](action) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.systemTextField.text = "system1"
                weakSelf.externalSystemActionSheetController?.dismiss(animated: true, completion: nil)
                }))
            externalSystemActionSheetController?.addAction(UIAlertAction(title: "system2", style: .default, handler: { [weak self](action) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.systemTextField.text = "system2"
                weakSelf.externalSystemActionSheetController?.dismiss(animated: true, completion: nil)
                }))
            externalSystemActionSheetController?.addAction(UIAlertAction(title: "system3", style: .default, handler: { [weak self](action) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.systemTextField.text = "system3"
                weakSelf.externalSystemActionSheetController?.dismiss(animated: true, completion: nil)
                }))
            externalSystemActionSheetController?.addAction(UIAlertAction(title: "system4", style: .default, handler: { [weak self](action) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.systemTextField.text = "system4"
                weakSelf.externalSystemActionSheetController?.dismiss(animated: true, completion: nil)
                }))
            externalSystemActionSheetController?.addAction(UIAlertAction(title: "system5", style: .default, handler: { [weak self](action) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.systemTextField.text = "system5"
                weakSelf.externalSystemActionSheetController?.dismiss(animated: true, completion: nil)
                }))
            externalSystemActionSheetController?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self](action) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.externalSystemActionSheetController?.dismiss(animated: true, completion: nil)
                }))
            
        }
        if let alertController = externalSystemActionSheetController {
            alertController.popoverPresentationController?.sourceView = systemTextField
            alertController.popoverPresentationController?.sourceRect = systemTextField.bounds
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showProfilePageViewController(signInType: SignUpTypes?) {
        let thirdPartyParameters: [String: String] = ["user_name": userIdTextField.text ?? "", "system": systemTextField.text ?? ""]
        Lava.tracker.trackEvent(category: "Profile screen", action: .checkOut, parameters: thirdPartyParameters)
        let profilePageViewCntrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        UserDefaults.standard.set(signInType?.rawValue, forKey: "signUpType")
        UserDefaults.standard.synchronize()
        if let _ = navigationController {
            self.navigationController!.pushViewController(profilePageViewCntrl, animated: false)
        }
    }
}

extension ThirdPartySignInViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.systemTextField {
            showActionController()
            return false
        }
        return true
    }
}
