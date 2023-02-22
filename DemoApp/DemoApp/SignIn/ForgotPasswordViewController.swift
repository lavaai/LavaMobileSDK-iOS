//
//  ForgotPasswordViewController.swift
//  DemoApp
//
//  Created by rohith on 01/02/16.
//  Copyright © 2016 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK

class ForgotPasswordViewController: UIViewController {
    
    var singleTap : UITapGestureRecognizer?
    var selectedSignUpType : SignUpTypes?
    var completionHandler: otpCompletionHandler?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var referenceViewConterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestNewPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func configureView() {
        singleTap = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.handleTap))
        singleTap?.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTap!)
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPasswordViewController.keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPasswordViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Lava.tracker.trackEvent(category: "ForgotPasswordScreen", action: .viewScreen)
        configureView()
        self.view.hideToastActivity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.removeGestureRecognizer(singleTap!)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        emailTextField.resignFirstResponder()
        return true
    }
    
    // MARK: - Notifications
    
    @objc func keyboardDidShow(notification : NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            if keyboardEndFrame!.isNull {
                return
            }
            let maxY: CGFloat = self.requestNewPasswordButton.frame.maxY
            let totalHeight: CGFloat = self.view.frame.height
            let diff: CGFloat = totalHeight - maxY
            let keyBoardHeight : CGFloat = keyboardEndFrame!.height
            if diff < keyBoardHeight {
                if notification.name == UIResponder.keyboardDidShowNotification {
                    let constraintPos: CGFloat = keyBoardHeight - diff
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.referenceViewConterYConstraint.constant -= constraintPos
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification : NSNotification) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.referenceViewConterYConstraint.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func showResetMobileOTPViewController() {
        if let mobileOTPViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetMobileOTPViewControllerIdentifier") as? ResetMobileOTPViewController {
            if let theNavigationController = navigationController {
                mobileOTPViewController.phoneNumber = emailTextField.text
                mobileOTPViewController.completionHandler = { [weak self] (userMobile,Password) in
                    guard let weakSelf = self else {
                        return
                    }
                    _ = weakSelf.navigationController?.popViewController(animated: false)
                    weakSelf.completionHandler?(userMobile,Password)
                }
                theNavigationController.pushViewController(mobileOTPViewController, animated: true)
            }
        }
    }
    
    //MARK: - Action method
    
    @IBAction func requestNewPasswordAction(_ sender: Any) {
        validateEmailOrPhoneNumber()
    }
    
    
    //MARK: - Private methods
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    func validateEmailOrPhoneNumber(){
        if emailTextField.text != "" {
            view.endEditing(true)
            if Utility.isValidEmail(emailTextField.text!) {
                selectedSignUpType = SignUpTypes.email
                moveToNext()
            } else if Utility.isValidPhoneNumber(emailTextField.text!) {
                selectedSignUpType = SignUpTypes.mobile
                moveToNext()
            } else {
                if Utility.isOnlyNumbers(emailTextField.text!){
                    Utility.displayAlertWith(self, title: "Invalid Mobile number", message: "You need to include country code along with your Mobile number", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                } else {
                    Utility.displayAlertWith(self, title: "Failure", message: "Invalid Email Id or Mobile Number", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                }
            }
            
        } else {
            Utility.displayAlertWith(self, title: "Incomplete Details", message: "You need to enter your valid credentials", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
        }
    }
    
    func moveToNext(){
        guard let _ = selectedSignUpType else {
            return
        }
        requestNewPasswordButton.isUserInteractionEnabled = false
        switch selectedSignUpType! {
        case SignUpTypes.email:
            view.makeToastActivity(.center)
            Lava.forgotPasswordForEmail(emailTextField.text!, completion: { [weak self](error) -> Void in
                if let strongSelf = self {
                    strongSelf.view.hideToastActivity()
                    strongSelf.requestNewPasswordButton.isUserInteractionEnabled = true
                    if let theError = error {
                        Utility.displayAlertWith(strongSelf, title: "Failure", message: theError.localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                    }
                    else {
                        Utility.displayAlertWith(strongSelf, title: "Success", message: "A password reset email has been sent to your email address", leftTitle: "OK", rightTitle: nil, completionHandler: { [weak self](alertaction) -> Void in
                            if nil == self {
                                return
                            } else {
                                if alertaction?.title == "OK"{
                                    _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                                } else {
                                    
                                }
                            }
                            })
                    }
                }
                })
        case SignUpTypes.mobile:
            view.makeToastActivity(.center)
            Lava.forgotPasswordForPhoneNumber(phoneNumber: emailTextField.text!, completion: { [weak self](error) -> Void in
                if let strongSelf = self {
                    strongSelf.view.hideToastActivity()
                    strongSelf.requestNewPasswordButton.isUserInteractionEnabled = true
                    if let theError = error {
                        Utility.displayAlertWith(strongSelf, title: "Failure", message: theError.localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                    }
                    else {
                        Utility.displayAlertWith(strongSelf, title: "Success", message: "SMS is sent to the provided number, with a one time password code for verification", leftTitle: "OK", rightTitle: nil, completionHandler: { [weak self](alertaction) -> Void in
                            if nil == self {
                                return
                            } else {
                                if alertaction?.title == "OK"{
                                    strongSelf.showResetMobileOTPViewController()
                                } else {
                                    
                                }
                            }
                            })
                    }
                }
                })
        case SignUpTypes.facebook:print("facebook login")
        case .thirdParty: print("Third party login")
        }
    }
    
}
