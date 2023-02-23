
//
//  MergeViewController.swift
//  DemoApp
//
//  Created by sharath on 23/02/16.
//  Copyright © 2016 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK

class MergeViewController: UITableViewController {
    
    @IBOutlet weak var externalIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var mergeTableView: UITableView!
    
    @IBOutlet weak var externalIdCell: UITableViewCell!
    @IBOutlet weak var passwordCell: UITableViewCell!
    @IBOutlet weak var confirmPasswordCell: UITableViewCell!
    @IBOutlet weak var nextButtonCell: UITableViewCell!
    
    var accountType: AccountTypes?
    var isExistingUser = false
    var showPasswordFields = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if showPasswordFields == true{
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(MergeViewController.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MergeViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    // MARK: - UITextFieldDelegate
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Notifications
    
    @objc func keyboardDidShow(_ notification : Notification) {
        if let userInfo = notification.userInfo {
            let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            if keyboardEndFrame!.isNull {
                return
            }
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            let maxY: CGFloat = self.mergeTableView.frame.maxY
            let totalHeight: CGFloat = self.view.frame.height
            let diff: CGFloat = totalHeight - maxY
            let keyBoardHeight : CGFloat = keyboardEndFrame!.height
            if diff < keyBoardHeight {
                if notification.name == UIResponder.keyboardDidShowNotification{
                    let constraintPos: CGFloat = keyBoardHeight + 150
                    UIView.animate(withDuration: duration, delay: 0.0, options: animationCurve, animations: { () -> Void in
                        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0,bottom: constraintPos, right: 0.0)
                        self.mergeTableView.contentInset = contentInsets
                        self.mergeTableView.scrollIndicatorInsets = contentInsets
                        self.view.layoutIfNeeded()
                        }, completion: nil)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification : Notification) {
        if let userInfo = notification.userInfo {
            let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            if keyboardEndFrame!.isNull {
                return
            }
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if notification.name == UIResponder.keyboardWillHideNotification {
                UIView.animate(withDuration: duration, delay: 0.0, options: animationCurve, animations: { () -> Void in
                    let contentInsets:UIEdgeInsets = UIEdgeInsets.zero;
                    self.mergeTableView.contentInset = contentInsets;
                    self.mergeTableView.scrollIndicatorInsets = contentInsets;
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    // MARK: - Action method
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if (!showPasswordFields) {
            //check if account exists
            if externalIdTextField.text != "" {
                if checkExternalId() {
                    if accountType == . externalSystem {
                        showPasswordFields = true
                        passwordTextField.placeholder = "Enter Your User ID"
                        mergeTableView.reloadData()
                        return
                    }
                    nextButton.isUserInteractionEnabled = false
                    view.makeToastActivity(ToastPosition.center)
                    Lava.checkIfAccountExists(externalId: externalIdTextField.text!, completion: { [weak self] (error) -> Void in
                        guard let weakSelf = self else { return }
                        weakSelf.view.hideToastActivity()
                        weakSelf.nextButton.isUserInteractionEnabled = true
                        if error == nil {
                            weakSelf.externalIdTextField.isUserInteractionEnabled = false
                            weakSelf.showPasswordFields = true
                            weakSelf.isExistingUser = true
                            weakSelf.passwordTextField.placeholder = "Enter your password"
                        } else {
                            weakSelf.showPasswordFields = true
                            weakSelf.isExistingUser = false
                            weakSelf.externalIdTextField.isUserInteractionEnabled = false
                        }
                        weakSelf.mergeTableView.reloadData()
                    })
                } else {
                    Utility.displayAlertWith(self, title: "Incorrect information", message: "Invalid \(accountType!.rawValue)", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                }
            } else {
                if let l_accountType = accountType {
                    switch l_accountType{
                    case .email:
                        Utility.displayAlertWith(self, title: "Incomplete information", message: "Enter Your Email Id", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                        break
                    case .phoneNumber:
                        Utility.displayAlertWith(self, title: "Incomplete information", message: "Enter Your Mobile Number with Country Code", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                        break
                    case .externalSystem:
                        Utility.displayAlertWith(self, title: "Incomplete information", message: "Enter Your External System Name", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                        break
                    default:
                        break
                    }
                }
            }
        } else {
            if isExistingUser == false {
                if accountType == .externalSystem {
                    if let count = passwordTextField.text?.count, count > 0 {
                        mergeNewAccount()
                    } else {
                        Utility.displayAlertWith(self, title: "Incomplete information", message: "Enter your user id again", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                    }
                } else {
                    if passwordTextField.text?.count ?? 0 >= 6 {
                        if passwordTextField.text == confirmPasswordTextField.text {
                            mergeNewAccount()
                        } else {
                            Utility.displayAlertWith(self, title: "Password Mismatch", message: "Enter the passwords again", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                            passwordTextField.text = ""
                            confirmPasswordTextField.text = ""
                        }
                    } else {
                        Utility.displayAlertWith(self, title: "Password Length Insufficient", message: "Your password must contain minimum 6 characters", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                    }
                }
            } else {
                if passwordTextField.text?.count ?? 0 >= 6 {
                    mergeExistingAccount()
                } else {
                    Utility.displayAlertWith(self, title: "Invalid Password", message: "Enter your password again", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
                }
            }
        }
    }
    
    @IBAction func handleTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if showPasswordFields {
                if accountType == .externalSystem {
                    return 2
                } else {
                    if (isExistingUser) {
                        return 2
                    } else {
                        return 3
                    }
                }
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    // MARK: - Private methods
    
    func initialSetUp(){
        //        passwordCell.hidden = true
        //        confirmPasswordCell.hidden = true
        if let l_accountType = accountType {
            switch l_accountType{
            case .email:
                externalIdTextField.placeholder = "Enter Email Address"
                externalIdTextField.keyboardType = .emailAddress
                passwordTextField.isSecureTextEntry = true
                break
            case .phoneNumber:
                externalIdTextField.placeholder = "Enter Mobile Number with Country Code"
                externalIdTextField.keyboardType = .phonePad
                passwordTextField.isSecureTextEntry = true
                break
            case .externalSystem:
                externalIdTextField.placeholder = "Enter External System Name"
                externalIdTextField.keyboardType = .emailAddress
                passwordTextField.isSecureTextEntry = false
                break
            default:
                break
            }
        }
    }
    
    func checkExternalId() -> Bool{
        if let l_accountType = accountType{
            switch l_accountType{
            case .email:
                return Utility.isValidEmail(externalIdTextField.text!)
            case .phoneNumber:
                return Utility.isValidPhoneNumber(externalIdTextField.text!)
            case .externalSystem:
                return true
            default:
                break
            }
        }
        return false
    }
    
    func mergeNewAccount() {
        if let l_accountType = accountType{
            switch l_accountType{
            case .email:
                Lava.linkWithEmail(email: externalIdTextField.text!, password: passwordTextField.text!, completion: { [weak self](user, error) -> Void in
                    if self == nil {
                        return
                    }
                    if error == nil {
                        Utility.displayAlertWith(self!, title: "Success", message: "Account was successfully linked. Verification mail has been sent to your email address. Please verify your account.", leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                            if alertaction?.title == "OK" {
                                _ = self!.navigationController?.popViewController(animated: true)
                            }
                        })
                    } else {
                        Utility.displayAlertWith(self!, title: "Failure", message: (error! as NSError).localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                            if alertaction?.title == "OK" {
                                _ = self!.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                    })
                break
            case .phoneNumber:
                Lava.linkWithPhoneNumber(phoneNumber: externalIdTextField.text!, password: passwordTextField.text!, completion: { [weak self](user, error) -> Void in
                    if self == nil {
                        return
                    }
                    if error == nil {
                        self!.showMobileOTPViewController()
                    } else {
                        Utility.displayAlertWith(self!, title: "Failure", message: (error! as NSError).localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                            if alertaction?.title == "OK" {
                                _ = self!.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                    })
                break
            case .externalSystem:
                view.makeToastActivity(ToastPosition.center)
                Lava.addId(systemName: externalIdTextField.text!, userId: passwordTextField.text!, completion: { [weak self](user, error) -> Void in
                    guard let weakSelf = self else { return }
                    weakSelf.view.hideToastActivity()
                    if error == nil {
                        Utility.displayAlertWith(weakSelf, title: "Success", message: "Account was successfully linked", leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                            if alertaction?.title == "OK" {
                                _ = weakSelf.navigationController?.popViewController(animated: true)
                            }
                        })
                    } else {
                        Utility.displayAlertWith(weakSelf, title: "Failure", message: (error! as NSError).localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                            if alertaction?.title == "OK" {
                                _ = weakSelf.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                })
                break
            default:
                break
            }
        }
    }
    
    
    func showMobileOTPViewController() {
        if let mobileOTPViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserOTPViewControllerIdentifier") as? UserOTPViewController {
            mobileOTPViewController.phoneNumber = externalIdTextField.text
            mobileOTPViewController.isLink = true
            if let theNavigationController = navigationController {
                theNavigationController.pushViewController(mobileOTPViewController, animated: true)
            }
        }
    }
    
    
    func mergeExistingAccount(){
        if let l_accountType = accountType{
            switch l_accountType {
            case .email:
                view.makeToastActivity(ToastPosition.center)
                Lava.linkWithExistingEmail(email: externalIdTextField.text!, password: passwordTextField.text!, completion: { [weak self](user, error) -> Void in
                    if self == nil {
                        return
                    }
                    self?.view.hideToastActivity()
                    if error == nil {
                        Utility.displayAlertWith(self!, title: "Success", message: "Account was successfully linked", leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                            if alertaction?.title == "OK" {
                                _ = self!.navigationController?.popViewController(animated: true)
                            }
                        })
                    } else {
                        Utility.displayAlertWith(self!, title: "Failure", message: (error! as NSError).localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                            if alertaction?.title == "OK" {
                                _ = self!.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                    })
                break
            case .phoneNumber:
                view.makeToastActivity(ToastPosition.center)
                Lava.linkWithExistingPhoneNumber(phoneNumber: externalIdTextField.text!, password: passwordTextField.text!, completion: { [weak self](user, error) -> Void in
                    if self == nil {
                        return
                    }
                    self?.view.hideToastActivity()
                    if error == nil {
                        Utility.displayAlertWith(self!, title: "Success", message: "Account was successfully linked", leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                            if alertaction?.title == "OK" {
                                _ = self!.navigationController?.popViewController(animated: true)
                            }
                        })
                    } else {
                        Utility.displayAlertWith(self!, title: "Failure", message: (error! as NSError).localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                            if alertaction?.title == "OK" {
                                _ = self!.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                    })
                break
            default:
                break
            }
        }
    }
}
