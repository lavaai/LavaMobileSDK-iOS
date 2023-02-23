//
//  MenuTableViewCell.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 10/12/2021.
//  Copyright © 2021 CodeCraft Technologies. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    static let CellId = "MenuTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            backgroundColor = UIColor.systemPurple
        } else {
            backgroundColor = UIColor.clear
        }
    }

}
