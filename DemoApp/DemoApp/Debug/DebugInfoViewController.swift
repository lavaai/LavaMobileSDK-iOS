//
//  DebugInfoViewController.swift
//  LavaSDK
//
//  Created by Shabeer on 2/7/19.
//

import UIKit
import UserNotifications
import LavaSDK

struct DebugItem {
    var key: String?
    var value: String?
}

class DebugInfoViewController: UIViewController {

    var debugInfo: DebugInfo? {
        didSet {
            guard let debugInfo = debugInfo else { return }
            buildDebugData(debugInfo: debugInfo)
        }
    }
    
    var data: [DebugItem] = []
    
    @IBOutlet weak var tvDebugInfo: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        tvDebugInfo.rowHeight = UITableView.automaticDimension
        tvDebugInfo.estimatedRowHeight = 80
    }
    
    func buildDebugData(debugInfo: DebugInfo) {
        data.append(DebugItem(key: "User ID", value: debugInfo.userId))
        data.append(DebugItem(key: "Email", value: debugInfo.email))
        data.append(DebugItem(key: "First Name", value: debugInfo.firstName))
        data.append(DebugItem(key: "Last Name", value: debugInfo.lastName))
        data.append(DebugItem(key: "Phone Number", value: debugInfo.phoneNumber))
        data.append(DebugItem(key: "User Type", value: debugInfo.userType))
        
        data.append(DebugItem(key: "Notification Token", value: debugInfo.notificationToken))
        
        data.append(DebugItem(key: "Authorization Token", value: debugInfo.authorizationToken))
        
        data.append(DebugItem(key: "Device ID", value: debugInfo.deviceId))
        data.append(DebugItem(key: "Device Name", value: debugInfo.deviceName))
        
        data.append(DebugItem(key: "Device Model", value: debugInfo.deviceModel))
        data.append(DebugItem(key: "Language", value: debugInfo.language))
        
        data.append(DebugItem(key: "IP Address", value: debugInfo.ipAddress))
        data.append(DebugItem(key: "OS Version", value: debugInfo.osVersion))
        data.append(DebugItem(key: "Platform", value: debugInfo.platform))
        data.append(DebugItem(key: "Screen Width", value: debugInfo.screenWidth))
        data.append(DebugItem(key: "Screen Height", value: debugInfo.screenHeight))
        
        data.append(DebugItem(key: "App Version", value: debugInfo.appVersion))
        data.append(DebugItem(key: "SDK Version", value: debugInfo.sdkVersion))
        data.append(DebugItem(key: "Server", value: debugInfo.server))
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension DebugInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DebugInfoTableViewCell.CellId, for: indexPath) as! DebugInfoTableViewCell
        cell.debugItem = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let debugItem = data[indexPath.row]
        print("[\(debugItem.key ?? "--")] \(debugItem.value ?? "--")")
    }
    
}
