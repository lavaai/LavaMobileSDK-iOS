//
//  DebugInfoTableViewCell.swift
//  LavaSDK
//
//  Created by Thuong Nguyen on 02/12/2021.
//  Copyright © 2021 CodeCraft Technologies. All rights reserved.
//

import UIKit

class DebugInfoTableViewCell: UITableViewCell {
    
    static let CellId = "DebugInfoCell"
    
    // Debug info item will be passed as a pair of string
    var debugItem: DebugItem? {
        didSet {
            guard let debugItem = debugItem else { return }
            lbTitle.text = debugItem.key
            lbContent.text = debugItem.value
        }
    }
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews() {
        
    }

}
