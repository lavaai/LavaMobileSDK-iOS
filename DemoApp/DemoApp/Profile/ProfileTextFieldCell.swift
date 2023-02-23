//
//  ProfileTextFieldCell.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 22/11/2021.
//

import UIKit
import LavaSDK

class ProfileTextFieldCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfValue: UITextField!
    
    var delegate: ProfileCellDelegate?
    var value: String?
    private var readOnly: Bool = false
    
    var cellMode: ProfileMode? {
        didSet {
            guard let mode = cellMode else { return }
            
            switch mode {
            case .edit :
                guard !readOnly else { return }
                tfValue.isUserInteractionEnabled = true
                tfValue.textColor = UIColor.black
                tfValue.textAlignment = .right
            case .view :
                tfValue.isUserInteractionEnabled = false
                tfValue.textColor = UIColor.lightGray
                tfValue.textAlignment = .right
            }
        }
    }
    
    var cellType : ProfileItem? {
        didSet {
            guard let cellType = cellType else { return }
            lbTitle.text = cellType.rawValue
            tfValue.text = value
            readOnly = cellType == .email
        }
    }
    
    @IBAction func textFieldValueChangeAction(_ sender: Any) {
        guard let text = (sender as? UITextField)?.text else { return }
        guard let cellType = cellType else { return }
        delegate?.onUpdate(key: cellType, value: text)
        value = text
    }
}

extension ProfileTextFieldCell: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    override open func resignFirstResponder() -> Bool {
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

