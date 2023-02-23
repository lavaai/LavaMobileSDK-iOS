//
//  MessageInboxTableViewCell.swift
//  DemoApp
//
//  Created by Muhameed Shabeer on 01/08/18.
//  Copyright © 2018 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK

class MessageTableViewCell: UITableViewCell {

    struct Nib {
        static let Name = "MessageTableViewCell"
    }
    
    struct Identifier {
        static let Name = "MessageCell"
    }
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbMessageId: UILabel!
    @IBOutlet weak var lbCreatedAt: UILabel!
    @IBOutlet weak var lbExpiresAt: UILabel!
    @IBOutlet weak var vCheckbox: UIView!
    @IBOutlet weak var lbExpiryDays: UILabel!
    
    var message: Message? {
        didSet {
            guard let message = message else { return }
            populateData(message: message)
        }
    }
    
    func populateData(message: Message) {
        lbTitle.text = message.messageId
        lbMessageId.text = "\(message.title ?? "--")"

        if let createdAt = message.createdAt {
            lbCreatedAt.text = "Created at: \(createdAt)"
        }
        if let expiresAt = message.expiresAt {
            lbExpiresAt.text = "Expiry date: \(formatDate(date: expiresAt))"
            
            let daysLeft = getDaysLeft(date: expiresAt)
            
            if daysLeft <= 0 {
                lbExpiryDays.textColor = UIColor.red
                lbExpiryDays.text = "Expired"
            } else {
                lbExpiryDays.textColor = UIColor.systemGray
                lbExpiryDays.text = "Expired after \(daysLeft) days"
            }
        }
        
        if let read = message.read, read {
            vCheckbox.isHidden = true
            backgroundColor = UIColor.clear
        } else {
            vCheckbox.isHidden = false
            backgroundColor = UIColor.systemGray6
        }
    }
}

extension MessageTableViewCell {
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    func getDaysLeft(date: Date) -> Int {
        let calendar = Calendar.current
        let result = calendar.dateComponents([.day], from: Date(), to: date)
        return result.day ?? 0
    }
    
}
