//
//  MessageInboxViewController.swift
//  DemoApp
//
//  Created by Muhameed Shabeer on 25/07/18.
//  Copyright © 2018 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK

enum MessageState {
    case all
    case read
    case unread
}

class MessagesViewController: UIViewController {
    
    var messages = [Message]()
    var filteredMessages: [Message]? = nil
    var selectedMessages = [String]()
    var refreshControl = UIRefreshControl()
    var inboxMessageState = MessageState.all
    var messageTag: String?
    var showExpiredMessages: Bool = true
    var hasFilter: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        getMessages { [weak self] in
            self?.view.hideLoading()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.parent?.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        isEditing = false
    }
    
    func setupViews() {
        self.title = "Inbox"
        
        // Nav bar
        self.navigationController?.parent?.navigationItem.rightBarButtonItem = editButtonItem
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(
            self,
            action: #selector(handleRefresh),
            for: UIControl.Event.valueChanged
        )
        
        registerCell()
        
        self.view.showLoading(.center)
    }
    
    func getMessages(includeExpired: Bool = true, callback: (() -> Void)? = nil) {
        Lava.shared.getMessages { [weak self] messageList in
            if includeExpired {
                self?.messages = messageList.messages
            } else {
                self?.messages = messageList.messages.filter({ !$0.isExpired() })
            }
            
            self?.messages.sort(by: { a, b in
                let idA = Int(a.messageId ?? "0") ?? 0
                let idB = Int(b.messageId ?? "0") ?? 0
                return idA > idB
            })
            
            self?.tableView.reloadData()
            callback?()
        } onError: { error in
            // TODO: Show error
            callback?()
        }
    }
    
    func registerCell() {
        self.tableView.register(
            UINib(nibName: "MessageTableViewCell", bundle: nil),
            forCellReuseIdentifier: "MessageCell")
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            inboxMessageState = .all
        case 1:
            inboxMessageState = .unread
        default:
            inboxMessageState = .read
        }
        
        self.view.showLoading(.center)
        
        selectedMessages.removeAll()
        
        // TODO: Filter messages by read / unread
        getMessages { [weak self] in
            self?.view.hideLoading()
        }
    }
    
    
    //MARK:- Action methods
    @objc func handleRefresh() {
        self.view.showLoading(.center)
        
        getMessages { [weak self] in
            self?.view.hideLoading()
        }
        
        refreshControl.endRefreshing()
    }
    
    @objc func deleteMultipleRows() {
        deleteMessages()
    }
    
    @objc func markReadMultipleRows() {
        markMessages(read: true)
    }
    
    @objc func markUnreadMultipleRows() {
        markMessages(read: false)
    }
    
    func markMessages(read: Bool) {
        guard selectedMessages.count > 0 else {
            isEditing = false
            return
        }
        
        self.view.showLoading(.center)
        
        let messageReadUpdate = MessageReadUpdate(
            read: read,
            ids: selectedMessages
        )

        Lava.shared.markMessages(messageReadUpdate: messageReadUpdate) { [weak self] result in
            self?.view.hideLoading()
            self?.onFinishMarkMessages(read: read)
        } onError: { error in
            // TODO: Show error popup
        }
    }
    
    func onFinishMarkMessages(read: Bool) {
        for index in messages.indices {
            guard let messageId = messages[index].messageId else { continue }
            if selectedMessages.contains(messageId) {
                messages[index].read = read
            }
        }
        selectedMessages.removeAll()
        tableView.reloadData()
        isEditing = false
    }
    
    func deleteMessages() {
        guard selectedMessages.count > 0 else {
            isEditing = false
            return
        }
        self.view.showLoading(.center)
        
        let messageIds = MessageIds(ids: selectedMessages)
        
        Lava.shared.batchDeleteMessages(messageIds: messageIds) { [weak self] result in
            self?.view.hideLoading()
            self?.onFinishDeleteMessages()
        } onError: { error in
            // TODO: Handle error
        }
    }
    
    func onFinishDeleteMessages() {
        messages = messages.filter({ message in
            guard let messageId = message.messageId else { return false }
            return selectedMessages.contains(messageId)
        })
        
        selectedMessages.removeAll()
        tableView.reloadData()
        isEditing = false
    }

}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let messageId = messages[indexPath.row].messageId else { return }
        selectedMessages.append(messageId)
        deleteMessages()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(editing, animated: true)
        if isEditing == true {
            setToolBar()
        } else {
            hideToolBar()
            selectedMessages.removeAll()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let messageId = messages[indexPath.row].messageId else { return }
        let cell = tableView.cellForRow(at: indexPath)
        selectedMessages.append(messageId)
        if isEditing {
            cell?.selectionStyle = UITableViewCell.SelectionStyle.default
        } else {
            let message = messages[indexPath.row]
            Lava.shared.showNotification(messageId: messageId, payload: message.payload)
            
            if let messageId = message.messageId {
                let messageUpdate = MessageReadUpdate(
                    read: true,
                    ids: [messageId]
                )
                
                Lava.shared.markMessages(
                    messageReadUpdate: messageUpdate) { [weak self] _ in
                        self?.messages[indexPath.row].read = true
                        tableView.reloadData()
                    } onError: { err in
                        print(err)
                    }

            }
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            selectedMessages.removeAll()
        }
    }

    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let messageId = messages[indexPath.row].messageId else { return }
        guard let index = selectedMessages.firstIndex(of: messageId) else { return }
        selectedMessages.remove(at: index)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func hideToolBar() {
        self.navigationController?.isToolbarHidden = true
    }
    
    func setToolBar() {
        self.navigationController?.isToolbarHidden = false
        
        let btnDelete = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteMultipleRows)
        )
        
        let btnRead = UIBarButtonItem(
            title: "Read",
            style: .plain,
            target: self,
            action: #selector(markReadMultipleRows)
        )
        
        let btnUnread = UIBarButtonItem(
            title: "Unread",
            style: .plain,
            target: self,
            action:#selector(markUnreadMultipleRows)
        )
        
        let space = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        self.navigationController?.toolbar.items = [
            btnRead,
            space,
            btnUnread,
            space,
            btnDelete
        ]
    }
}

extension MessagesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
}

