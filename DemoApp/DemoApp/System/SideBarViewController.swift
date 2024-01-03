//
//  SideBarViewController.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 13/09/2023.
//  Copyright © 2023 LAVA. All rights reserved.
//

import UIKit

enum MenuItem: String {
    case profile = "Profile"
    case messages = "Messages"
    case analytics = "Analytics"
    case debugInfo = "Debug Info"
    case membershipCard = "Membership Card"
    case logOut = "Log Out"
}

protocol MenuDelegate {
    func onSelectMenuItem(_ menuItem: MenuItem)
    func closeMenu()
}

class SideBarViewController: UIViewController {
    
    var menuItems: [MenuItem] = [
        .profile,
        .messages,
        .analytics,
        .membershipCard,
        .debugInfo,
        .logOut
    ]

    var tableView: UITableView!
    var ivBackground: UIImageView!
    var selectedMenuItem: MenuItem = .profile
    var delegate: MenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupViews() {
        
        ivBackground = UIImageView(frame: CGRectZero)
        ivBackground.image = UIImage(named: "bg")
        ivBackground.contentMode = .scaleAspectFill
        ivBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ivBackground)
        view.addConstraints([
            view.topAnchor.constraint(equalTo: ivBackground.topAnchor),
            view.leftAnchor.constraint(equalTo: ivBackground.leftAnchor),
            view.rightAnchor.constraint(equalTo: ivBackground.rightAnchor),
            view.bottomAnchor.constraint(equalTo: ivBackground.bottomAnchor),
        ])
        
        
        tableView = UITableView(frame: CGRectZero)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.CellId)
        
        tableView.backgroundColor = .clear
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            view.topAnchor.constraint(equalTo: tableView.topAnchor, constant: -100),
            view.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: -16),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            view.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 2, constant: 0)
        ])
    }
}

extension SideBarViewController: UITableViewDataSource, UITableViewDelegate {
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
            cell.textLabel?.textColor = AppColor.secondary
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        guard let label = cell?.textLabel else {
            return
        }
        
        guard let menuItem = MenuItem(rawValue: label.text!) else {
            return
        }
        
        if menuItem == .logOut || menuItem == .membershipCard {
            delegate?.onSelectMenuItem(menuItem)
        } else if menuItem != selectedMenuItem {
            selectedMenuItem = menuItem
            delegate?.onSelectMenuItem(menuItem)
            delegate?.closeMenu()
        } else {
            delegate?.closeMenu()
        }
        
        tableView.reloadData()
    }
}


