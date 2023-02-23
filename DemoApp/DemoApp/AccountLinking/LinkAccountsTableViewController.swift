//
//  LinkAccountsTableViewController.swift
//  DemoApp
//
//  Created by sharath on 22/02/16.
//  Copyright © 2016 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK

public enum AccountTypes : String {
    case email = "Email"
    case phoneNumber = "Phone Number"
    case facebook = "Facebook"
    case externalSystem = "External System"
}


class LinkAccountsTableViewController: UITableViewController {

    struct Section {
        var type: AccountTypes
        var items: [LavaUserAccount]
    }
    
    var accounts = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LinkAccountHeaderFooterView", bundle: Bundle.main)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "LinkAccountHeaderFooterView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Lava.tracker.trackEvent(category: "LinkAccountsScreen", action: .viewScreen)
        filterAccounts()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return accounts.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkAccountTableViewCell", for: indexPath) as! LinkAccountTableViewCell
        cell.userAccount = accounts[indexPath.section].items[indexPath.row]
        cell.configureAccountCell()
        cell.completionBlock = {
            [weak self](accountType) -> Void in
            guard let weakSelf = self else {
                return
            }
            if accountType != AccountTypes.facebook {
                let mergeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MergeViewController") as! MergeViewController
                mergeViewController.accountType = accountType as AccountTypes
                weakSelf.navigationController?.pushViewController(mergeViewController, animated: true)
            } else {
                weakSelf.view.makeToastActivity(.center)
                Lava.linkWithFacebook(currentViewController: weakSelf, completion: { [weak self](user, error) -> Void in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.view.hideToastActivity()
                    if error == nil {
                        if user != nil {
                            Utility.displayAlertWith(weakSelf, title: "Success", message: "Account was successfully linked", leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                                if alertaction?.title == "OK" {
                                    _ = weakSelf.navigationController?.popViewController(animated: true)
                                    weakSelf.tableView.reloadData()
                                }
                            })
                        }
                    } else {
                        Utility.displayAlertWith(weakSelf, title: "Failure", message: (error! as NSError).localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                            if alertaction?.title == "OK" {
                                _ = weakSelf.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                    })
                
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return accounts[section].type.rawValue
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LinkAccountHeaderFooterView") as! LinkAccountHeaderFooterView
        header.titleLable.text = accounts[section].type.rawValue.uppercased()
        header.didLinkButtonTappedCompletion = { [weak self] () -> Void in
            guard let weakSelf = self else {
                return
            }
            let accountType = weakSelf.accounts[section].type
            if accountType != AccountTypes.facebook {
                weakSelf.showMergeViewController(type: accountType)
            } else {
                weakSelf.view.makeToastActivity(.center)
                Lava.linkWithFacebook(currentViewController: weakSelf, completion: { [weak self](user, error) -> Void in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.view.hideToastActivity()
                    if error == nil {
                        if user != nil {
                            Utility.displayAlertWith(weakSelf, title: "Success", message: "Account was successfully linked", leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                                if alertaction?.title == "OK" {
                                    _ = weakSelf.navigationController?.popViewController(animated: true)
                                    weakSelf.tableView.reloadData()
                                }
                            })
                        }
                    } else {
                        Utility.displayAlertWith(weakSelf, title: "Failure", message: (error! as NSError).localizedDescription, leftTitle: "OK", rightTitle: nil, completionHandler: { (alertaction) -> Void in
                            if alertaction?.title == "OK" {
                                _ = weakSelf.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                })
                
            }
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height * 0.16
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func showMergeViewController(type: AccountTypes) {
        let mergeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MergeViewController") as! MergeViewController
        mergeViewController.accountType = type
        navigationController?.pushViewController(mergeViewController, animated: true)
    }
    
    func filterAccounts() {
        let userAccounts = Lava.currentUser?.accounts
        var phoneAccounts = [LavaUserAccount]()
        var emailAccounts = [LavaUserAccount]()
        var facebookAccounts = [LavaUserAccount]()
        var thirdPartyAccounts = [LavaUserAccount]()
        if let usrAccounts = userAccounts {
            for account in usrAccounts {
                if account.externalSystem?.lowercased() == "email" {
                    emailAccounts.append(account)
                } else if account.externalSystem?.lowercased() == "phone" {
                    phoneAccounts.append(account)
                } else if account.externalSystem?.lowercased() == "facebook" {
                    facebookAccounts.append(account)
                } else {
                    thirdPartyAccounts.append(account)
                }
            }
        }
        accounts = [Section(type: AccountTypes.email, items: emailAccounts), Section(type: AccountTypes.phoneNumber, items: phoneAccounts), Section(type: AccountTypes.facebook, items: facebookAccounts), Section(type: AccountTypes.externalSystem, items: thirdPartyAccounts)]
    }
}
