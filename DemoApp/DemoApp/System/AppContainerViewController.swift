//
//  AppContainerViewController.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 12/09/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import UIKit
import LavaSDK

public let NotificationNameOpenMenu = Notification.Name("openMenu")

class AppContainerViewController: UIViewController {
    
    var sidebarVC: SideBarViewController!
    var contentVC: UINavigationController!
    
    static func create() -> AppContainerViewController {
        return AppContainerViewController()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(openMenu), name: NotificationNameOpenMenu, object: nil)
    }
    
    func setupViews() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sidebarVC = SideBarViewController()
        sidebarVC.view.frame = view.frame
        sidebarVC.delegate = self
        view.addSubview(sidebarVC.view)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        contentVC = UINavigationController(rootViewController: homeVC)
        contentVC.navigationBar.tintColor = UIColor.darkGray

        
        view.addSubview(contentVC.view)
    }
    
    func setupGestures() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(animateCloseMenu(_:)))
        rightSwipe.direction = .left
        
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(animateOpenMenu(_:)))
        leftSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
    }
    
    func makeContentViewTransform() -> CATransform3D {
        var transform = CATransform3DIdentity;
        transform.m34 = 1.0 / 200.0;
        transform = CATransform3DRotate(transform, 0.1, 0, 1.0, 0)
        transform = CATransform3DTranslate(transform, view.frame.width * 2 / 3, 0, 100)
        return transform
    }
    
    @objc func animateCloseMenu(_ sender: UISwipeGestureRecognizer?) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.contentVC.view.layer.cornerRadius = 0.0
            strongSelf.contentVC.view.layer.transform = CATransform3DIdentity
        }
    }
    
    @objc func animateOpenMenu(_ sender: UISwipeGestureRecognizer?) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.contentVC.view.layer.cornerRadius = 10.0
            strongSelf.contentVC.view.layer.transform = strongSelf.makeContentViewTransform()
        }
    }
    
    @objc func openMenu() {
        animateOpenMenu(nil)
    }
}

extension AppContainerViewController: MenuDelegate {
    func onSelectMenuItem(_ menuItem: MenuItem) {
        switch(menuItem) {
        case .profile:
            Navigator.shared.openProfile(contentVC)
            break
        case .messages:
            Navigator.shared.openMessages(contentVC)
            break
        case .debugInfo:
            Navigator.shared.openDebug(contentVC)
            break
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
    
    func closeMenu() {
        animateCloseMenu(nil)
    }
}
