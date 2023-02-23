//
//  RegisterViewController.swift
//  DemoApp1
//
//  Created by rohith on 21/01/16.
//  Copyright © 2016 codecraft. All rights reserved.
//

import UIKit
import LavaSDK

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var phoneOrEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    @IBOutlet weak var facebookSignupButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var viewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerView: UIView!
    
    var singleTap : UITapGestureRecognizer?
    var selectedSignUpType : SignUpTypes?
    var phoneNumberRegistrationCompletionHandler : otpCompletionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Lava.tracker.trackEvent(category: "RegisterScreen", action: .viewScreen)
        super.viewWillAppear(animated)
        clearAllTextFields()
        singleTap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.handleTap))
        singleTap?.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTap!)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        viewCenterYConstraint.constant = 0.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.removeGestureRecognizer(singleTap!)
        NotificationCenter.default.removeObserver(self)
        view.endEditing(true)
    }
    
    func showProfilePageViewController() {
        let profilePageViewCntrl:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
        UserDefaults.standard.set(SignUpTypes.facebook.rawValue, forKey: "signUpType")
        UserDefaults.standard.synchronize()
        if let _ = navigationController {
            self.navigationController!.pushViewController(profilePageViewCntrl, animated: false)
        }
    }
    
    func showMobileOTPViewController() {
        if let mobileOTPViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserOTPViewControllerIdentifier") as? UserOTPViewController {
            mobileOTPViewController.phoneNumber = phoneOrEmailTextField.text
            mobileOTPViewController.completion = { [weak self] () in
                guard let weakSelf = self else {
                    return
                }
                _ = weakSelf.navigationController?.popViewController(animated: false)
                weakSelf.phoneNumberRegistrationCompletionHandler?(weakSelf.phoneOrEmailTextField.text!,weakSelf.passwordTextField.text!)
            }
            if let theNavigationController = navigationController {
                theNavigationController.pushViewController(mobileOTPViewController, animated: true)
            }
        }
    }

    //MARK:- Keyboard Notifications
    @objc func keyboardDidShow(_ notification : Notification) {
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
    
    @objc func keyboardWillHide(_ notification : Notification) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.viewCenterYConstraint.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    //MARK:- Private methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        phoneOrEmailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        reEnterPasswordTextField.resignFirstResponder()
        return true
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    func clearAllTextFields(){
        phoneOrEmailTextField.text = ""
        passwordTextField.text = ""
        reEnterPasswordTextField.text = ""
    }
    
    func validateEmailOrPhoneNumber(){
        if phoneOrEmailTextField.text != "" || passwordTextField.text != "" ||  reEnterPasswordTextField.text != "" {
            if Utility.isValidEmail(phoneOrEmailTextField.text!) {
                selectedSignUpType = SignUpTypes.email
                validatePassword()
            } else if Utility.isValidPhoneNumber(phoneOrEmailTextField.text!) {
                selectedSignUpType = SignUpTypes.mobile
                validatePassword()
            } else {
                if Utility.isOnlyNumbers(phoneOrEmailTextField.text!){
                    Utility.displayAlertWith(self, title: "Invalid Mobile number", message: "You need to include country code along with your Mobile number", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                } else {
                    Utility.displayAlertWith(self, title: "Failure", message: "Invalid Email Id or Mobile Number", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                }
            }
        } else {
            Utility.displayAlertWith(self, title: "Incomplete Details", message: "You need to enter your valid details to Sign Up.", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
        }
        
    }
    
    func validatePassword() {
        if passwordTextField.text == reEnterPasswordTextField.text {
            if passwordTextField.text?.count ?? 0 < 6 {
                Utility.displayAlertWith(self, title: "Password Length Insufficient", message: "Your password must contain minimum 6 characters", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
            }
            else{
                ///Sucess
                moveToNext()
            }
        } else {
            Utility.displayAlertWith(self, title: "Password Mismatch", message: "Enter the passwords again", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
            passwordTextField.text = ""
            reEnterPasswordTextField.text = ""
        }
    }
    
    func showSignInViewController() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func moveToNext(){
        signUpButton.isUserInteractionEnabled = false
        guard let _ = selectedSignUpType else {
            return
        }
        switch selectedSignUpType!{
        case SignUpTypes.email:
            view.makeToastActivity(ToastPosition.center)
            Lava.signUpWithEmail(email: phoneOrEmailTextField.text!, password: passwordTextField.text!) {
                [weak self](error) -> Void in
                if self == nil {
                    return
                }
                self?.view.hideToastActivity()
                self?.signUpButton.isUserInteractionEnabled = true
                if error == nil {
                    
                    Utility.displayAlertWith(self!, title: "Verification", message: "Verification mail has been sent to your email address. Please verify your account and then Sign in", leftTitle: "OK", rightTitle: nil, completionHandler: { [weak self](alertaction) -> Void in
                        if nil == self {
                            return
                        } else {
                            if alertaction?.title == "OK"{
                                self!.showSignInViewController()
                            } else {
                                
                            }
                        }
                        })
                    let registerParameter: [String: String] = ["user_name": self?.phoneOrEmailTextField.text ?? ""]
                    Lava.tracker.trackEvent(category: "Authentication email register", action: .click, parameters: registerParameter)
                } else {
                    Utility.displayAlertWith(self!, title: "Registration Failed", message: error!.localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                }
            }
        case SignUpTypes.mobile:
            view.makeToastActivity(ToastPosition.center)
            Lava.signUpWithPhoneNumber(phoneNumber: phoneOrEmailTextField.text!, password: passwordTextField.text! ,completion: {
                [weak self](error) -> Void in
                if self == nil {
                    return
                }
                self?.view.hideToastActivity()
                self?.signUpButton.isUserInteractionEnabled = true
                if error == nil {
                    self?.showMobileOTPViewController()
                    let mobileRegisterParameter: [String: String] = ["mobile": self?.phoneOrEmailTextField.text ?? ""]
                    Lava.tracker.trackEvent(category: "Authentication mobile register", action: .click, parameters: mobileRegisterParameter)
                }else if error?.code == LavaErrorCode.accountExistsVerificationPending.rawValue {
                    Utility.displayAlertWith(self!, title: "Registration Failed", message: error!.localizedDescription, leftTitle: "OK", rightTitle: "Verify", completionHandler: { [weak self](alertaction) -> Void in
                        if nil == self {
                            return
                        } else {
                            if alertaction?.title == "Verify"{
                                self?.showMobileOTPViewController()
                            }
                        }
                        })
                }else {
                    Utility.displayAlertWith(self!, title: "Registration Failed", message: error!.localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                }
                })
            case SignUpTypes.facebook:print("facebook login")
            case .thirdParty: print("Third party login")
        }
    }
    
    //MARK:- Action methods
    
    @IBAction func signUpAction(_ sender: Any) {
        view.endEditing(true)
        validateEmailOrPhoneNumber()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        showSignInViewController()
    }
    
}
