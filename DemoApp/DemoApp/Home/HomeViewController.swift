//
//  HomeViewController.swift
//  DemoApp
//
//  Created by sharath on 19/02/16.
//

import UIKit
import LavaSDK

enum MenuItem: String {
    case profile = "Profile"
    case messages = "Messages"
    case debugInfo = "Debug Info"
    case logOut = "Log Out"
}


class HomeViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    var menuItems: [MenuItem] = [
        .profile,
        .messages,
        .debugInfo,
        .logOut
    ]
    
    var currentViewController:UINavigationController? = nil
    var selectedMenuItem: MenuItem = .profile
    var swipeGesture: UISwipeGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(toggleSideMenu))
        
        swipeGesture!.direction = UISwipeGestureRecognizer.Direction.up
        
        self.menuView.addGestureRecognizer(swipeGesture!)
        self.menuView.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
        getVersionAndBuildNumber()
        setupNavigationBar()
        proceedMenuItem()
        menuView.transform.tx = -view.frame.size.width
        
        menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.CellId)
    }
    
    func setupNavigationBar(){
        
        self.navigationItem.title = selectedMenuItem.rawValue
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ic_menu"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(HomeViewController.toggleSideMenu)
        )
        
    }
    
    @objc func toggleSideMenu() {
        guard isFirstViewControllerShown() else {
            _ = currentViewController?.popViewController(animated: true)
            return
        }
        
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "menuPressed"),
            object: nil
        )
        
        if menuView.transform.tx < 0 {
            self.navigationItem.leftBarButtonItem?.image = UIImage(named: "ic_back")
            swipeGesture!.direction = UISwipeGestureRecognizer.Direction.left
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, animations: {
                [weak self]() -> Void in
                self?.menuView.transform.tx = 0
                self!.view.layoutIfNeeded()
                }, completion: { [weak self](value) -> Void in
                    if self == nil {
                        return
                    }
            })
        } else {
            self.navigationItem.leftBarButtonItem?.image = UIImage(named: "ic_menu")
            swipeGesture!.direction = UISwipeGestureRecognizer.Direction.right
            
            UIView.animate(withDuration: 0.2, animations: {
                [weak self]() -> Void in
                self?.menuView.transform.tx = -(self?.view.frame.width ?? 0)
                self!.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func proceedMenuItem() {
        
        if selectedMenuItem != .logOut {
            self.navigationItem.title = selectedMenuItem.rawValue
        }
        
        switch(selectedMenuItem) {
        case .profile:
            let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewControllerIdentifier") as? ProfileViewController
            profileViewController?.profileMode = .view
            showController(controller: profileViewController!)
            break
        case .messages:
            let messageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
            showController(controller: messageViewController)
            break
        case .debugInfo:
            let debugInfoVC = storyboard?.instantiateViewController(withIdentifier: "DebugInfoViewController") as! DebugInfoViewController
            debugInfoVC.debugInfo = Lava.shared.getDebugInfo()
            showController(controller: debugInfoVC)
        case .logOut:
            view.showLoading(.center)
            Lava.shared.setEmail(email: nil) { [weak self] in
                self?.view.hideLoading()
                Navigator.shared.goToSignIn()
            } onError: {  [weak self] err in
                self?.view.hideLoading()
                self?.showAlert(title: "Error", message: err.localizedDescription)
            }

            break
        }
    }
    
    @discardableResult func showController(controller: UIViewController) -> UINavigationController {
        
        if currentViewController != nil {
            Utility.removeChildController(currentViewController!, fromParentController: self, fromContainerView: containerView)
        }
        
        let navCtr = UINavigationController(rootViewController: controller)
        navCtr.isNavigationBarHidden = true
        
        Utility.parentController(
            self,
            withContainer: containerView,
            withChildController: navCtr,
            withFrameWidth: (NSInteger)(self.view.frame.width),
            align: ViewAlignType.alignCenter
        )
        
        navCtr.delegate = self
        currentViewController = navCtr
        return navCtr
    }
    
    func getVersionAndBuildNumber() {
        versionLabel.text = Utility.appVersion()
        buildLabel.text = "Project - Swift 5"
    }
    
    func configureLeftToBarButton() {
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "ic_menu")
        if false == isFirstViewControllerShown() {
            self.navigationItem.leftBarButtonItem?.image = UIImage(named: "ic_back")
        }
    }
    
    func isFirstViewControllerShown() -> Bool {
        var isFirst = false
        if let currentViewController = currentViewController {
            isFirst = currentViewController.viewControllers.first ===  currentViewController.viewControllers.last
        }
        return isFirst
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.CellId, for: indexPath)
        
        cell.textLabel?.text = menuItems[indexPath.row].rawValue
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        if menuItems[indexPath.row] == selectedMenuItem {
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            cell.textLabel?.textColor = UIColor(red: 236/255, green: 0, blue: 134/255, alpha: 100)
        }
        return cell
    }

}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        guard let label = cell?.textLabel else {
            return
        }
        
        if let menuItem = MenuItem(rawValue: label.text!) {
            if menuItem == .logOut {
                selectedMenuItem = menuItem
                proceedMenuItem()
            } else if menuItem != selectedMenuItem {
                selectedMenuItem = menuItem
                proceedMenuItem()
                toggleSideMenu()
            } else {
                toggleSideMenu()
            }
        }
        
        tableView.reloadData()
    }
}

extension HomeViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        configureLeftToBarButton()
    }
}
