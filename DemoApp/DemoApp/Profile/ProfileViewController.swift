//
//  ProfileViewController.swift
//  DemoApp
//
//  Created by rohith on 22/01/16.
//

import UIKit
import LavaSDK

enum ProfileItem: String {
    case firstName = "First Name"
    case lastName = "Last Name"
    case phoneNumber = "Phone Number"
    case email = "Email"
}

protocol ProfileCellDelegate {
    func onUpdate(key: ProfileItem, value: String)
}

class ProfileViewController: UIViewController {

    var fields: [ProfileItem] = [
        .firstName,
        .lastName,
        .phoneNumber,
        .email
    ]
    
    var data: [ProfileItem: String?]?
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var singleTap : UITapGestureRecognizer?
    var activeTextField : UITextField?
    var profileMode : ProfileMode!
    var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleTap))
        
        singleTap?.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(singleTap!)
        
        self.navigationItem.title = "Profile"
        
        changeMode(.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.menuPressed), name: NSNotification.Name(rawValue: "menuPressed"), object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.removeGestureRecognizer(singleTap!)
        
        NotificationCenter.default.removeObserver(self)
        
        view.endEditing(true)
        view.hideLoading()
        
        self.navigationController?.parent?.navigationItem.rightBarButtonItem = nil
    }
    
    //MARK:- Private methods
    
    func changeMode(_ mode: ProfileMode){
        profileMode = mode
        switch profileMode {
        case .view :
            let btnEdit = UIBarButtonItem(
                title: "Edit",
                style: UIBarButtonItem.Style.plain,
                target: self,
                action: #selector(onEditProfile)
            )
            
            self.navigationController?.parent?.navigationItem.rightBarButtonItem = btnEdit
            self.navigationController?.parent?.navigationItem.title = "Profile"
            
        case .edit :
            let btnUpdate = UIBarButtonItem(
                title: "Save",
                style: UIBarButtonItem.Style.plain,
                target: self,
                action: #selector(onUpdateProfile)
            )
            self.navigationController?.parent?.navigationItem.rightBarButtonItem = btnUpdate
            self.navigationController?.parent?.navigationItem.title = "Edit Profile"
        default:
            break
        }
    }
    
    func getProfile() {
        view.showLoading(.center)
        Lava.shared.getProfile { [weak self] userProfile in
            self?.view.hideLoading()
            self?.data = self?.buildUserInfoDict(userProfile: userProfile)
            self?.profileTableView.reloadData()
        } onError: { [weak self] error in
            print(error)
            // TODO: Handle error
            self?.view.hideLoading()
        }
    }
    
    func updateProfile(userProfile: UserProfile) {
        view.showLoading(.center)
        
        Lava.shared.updateProfile(userProfile: userProfile) { [weak self] userProfile in
            self?.view.hideLoading()
            self?.userProfile = userProfile
            self?.profileTableView.reloadData()
            self?.changeMode(.view)
        } onError: { [weak self] error in
            self?.view.hideLoading()
            print(error)
            // TODO: Handle error
        }
    }
    
    @objc func menuPressed(){
        view.endEditing(true)
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    //MARK:- Notifications
    
    @objc func keyboardDidShow(notification : NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        if keyboardEndFrame!.isNull {
            return
        }
        
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        let maxY: CGFloat = self.profileTableView.frame.maxY
        
        let totalHeight: CGFloat = self.view.frame.height
        
        let diff: CGFloat = totalHeight - maxY
        
        let keyBoardHeight : CGFloat = keyboardEndFrame!.height
        
        if diff < keyBoardHeight {
            if notification.name == UIResponder.keyboardDidShowNotification {
                let constraintPos: CGFloat = keyBoardHeight - diff + 50
                UIView.animate(withDuration: duration, delay: 0.0, options: animationCurve, animations: { () -> Void in
                    let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0,bottom: constraintPos, right: 0.0)
                    self.profileTableView.contentInset = contentInsets
                    self.profileTableView.scrollIndicatorInsets = contentInsets
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillHide(notification : NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
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
                self.profileTableView.contentInset = contentInsets;
                self.profileTableView.scrollIndicatorInsets = contentInsets;
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    // MARK: - Action Methods
    @objc func onEditProfile() {
        changeMode(.edit)
        profileTableView.reloadData()
    }
    
    @objc func onUpdateProfile() {
        view.endEditing(true)
        guard let data = data else { return }
        let userProfile = buildUserProfile(data: data)
        updateProfile(userProfile: userProfile)
    }
    
    @IBAction func fetchInAppPass(_ sender: Any) {
        Lava.shared.showPass()
    }
    
    func buildUserInfoDict(userProfile: UserProfile?) -> [ProfileItem: String?] {
        var ret = [ProfileItem: String?]()
        guard let userProfile = userProfile else { return ret }
        
        ret[.firstName] = userProfile.firstName
        ret[.lastName] = userProfile.lastName
        ret[.phoneNumber] = userProfile.phoneNumber
        ret[.email] = Lava.shared.getLavaUser()?.email
        
        return ret
    }
    
    func buildUserProfile(data: [ProfileItem: String?]?) -> UserProfile {
        var ret = UserProfile()
        if let data = data {
            ret.firstName = data[.firstName] ?? nil
            ret.lastName = data[.lastName] ?? nil
            ret.phoneNumber = data[.phoneNumber] ?? nil
        }
        return ret
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ProfileViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.profileTableView.dequeueReusableCell(withIdentifier: "ProfileTextFieldCell", for: indexPath) as! ProfileTextFieldCell
        let item = fields[indexPath.row]
        cell.value = data?[item] ?? "--"
        cell.delegate = self
        cell.cellType = item
        cell.cellMode = profileMode
        return cell
    }
}

extension ProfileViewController: ProfileCellDelegate {
    
    func onUpdate(key: ProfileItem, value: String) {
        data?[key] = value
    }
    
}
