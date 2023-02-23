//
//  LinkAccountTableViewCell.swift
//  DemoApp
//
//  Created by sharath on 22/02/16.
//  Copyright © 2016 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK

class LinkAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var externalIdLabel: UILabel!
    @IBOutlet weak var verificationStatusLabel: UILabel!
    @IBOutlet weak var verificationStatusActivityIndicator: UIActivityIndicatorView!
    
    var completionBlock: mergeCompletionBlock?
    var userAccount: LavaUserAccount?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureAccountCell() {
        verificationStatusActivityIndicator.stopAnimating()
//        linkStatusView.isHidden = true
//        linkAccountView.isHidden = false
        checkIfLinked()
    }
    
    func checkIfLinked() {
        if let usrAccount = userAccount, let externalSystem = usrAccount.externalSystem, let externalId = usrAccount.externalId {
            if (externalSystem == "email") || (externalSystem == "phone") || (externalSystem == "facebook") {
                externalIdLabel.text = externalId
            } else {
                externalIdLabel.text = "\(externalSystem) : \(externalId)"
            }
            verificationStatusActivityIndicator.startAnimating()
            if usrAccount.isVerified {
                self.verificationStatusLabel.text = "Status : Verified"
                verificationStatusActivityIndicator.stopAnimating()
            } else {
                checkIfVerified(externalId)
            }
        }
    }
    
    fileprivate func checkIfVerified(_ externalId: String) {
        Lava.checkVerificationStatus(externalId: externalId, completion: { [weak self](error) -> Void in
            if self == nil {
                return
            }
            self!.verificationStatusActivityIndicator.stopAnimating()
            if error == nil {
                self?.verificationStatusLabel.text = "Status : Verified"
            } else {
                self?.verificationStatusLabel.text = "Status : Not verified"
            }
            })
    }

//    @IBAction func linkButtonAction(_ sender: Any) {
//        if let l_accountType = accountType {
//            completionBlock?(l_accountType)
//        }
//    }
}
