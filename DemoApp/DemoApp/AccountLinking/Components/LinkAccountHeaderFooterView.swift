//
//  LinkAccountHeaderFooterView.swift
//  DemoApp
//
//  Created by srinath on 30/08/18.
//  Copyright © 2018 CodeCraft Technologies. All rights reserved.
//

import UIKit

class LinkAccountHeaderFooterView: UITableViewHeaderFooterView {

    typealias DidLinkButtonTapped = () -> Void

    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    
    var didLinkButtonTappedCompletion: DidLinkButtonTapped?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func linkButtonAction(_ sender: UIButton) {
        didLinkButtonTappedCompletion?()
    }
    
}
