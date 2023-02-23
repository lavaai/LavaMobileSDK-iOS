//
//  ProfileSegmentedCell.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 22/11/2021.
//  Copyright © 2021 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK

open class ProfileSegmentedCell: UITableViewCell {
    
    @IBOutlet weak var scValue: UISegmentedControl!
    @IBOutlet weak var lbTitle: UILabel!
    
    var delegate: ProfileCellDelegate?
    var value: String?
    
    var segmentCellMode: ProfileMode? {
        didSet {
            guard let segmentCellMode = segmentCellMode else { return }
            switch segmentCellMode {
            case .edit:
                scValue.isUserInteractionEnabled = true
            case .view:
                scValue.isUserInteractionEnabled = false
            }
        }
    }
    
    var cellType: ProfileItem? {
        didSet {
            guard let cellType = cellType else { return }
            lbTitle.text = cellType.rawValue

            
        }
    }
        
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        guard let cellType = cellType else { return }
        
        guard let value = value else { return }
        delegate?.onUpdate(key: cellType, value: value)
    }
    
    
}
