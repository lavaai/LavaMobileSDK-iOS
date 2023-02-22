//
//  BeaconListTableViewController.swift
//  DemoApp
//
//  Created by srinath on 22/01/16.
//  Copyright © 2016 CodeCraft Technologies. All rights reserved.
//

import UIKit
import LavaSDK
import CoreLocation

class BeaconListTableViewController: UITableViewController {
    
    @IBOutlet var beaconTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Lava.tracker.trackScreen("BeaconListScreen")
        NotificationCenter.default.addObserver(self, selector: #selector(RefreshBeaconList), name: Notification.Name(rawValue: ActiveBeaconUpdateNotification), object: nil)
        if Lava.areaMonitoringEnabled == false {
            view.makeToast("Area monitoring not enabled. Go to Settings to enable this.", duration: 5.0, position: ToastPosition.center)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Actions
    
    @IBAction func virtualAreaAction(_ sender: Any) {
        guard Lava.areaMonitoringEnabled else {
            view.makeToast("Area monitoring not enabled. Go to Settings to enable this.")
            return
        }
        if let segmentControl = sender as? UISegmentedControl {
            if segmentControl.selectedSegmentIndex == 0 {
                Lava.enterVirtualBeaconRegion(completion: { [weak self] (error) -> Void in
                    if let theError = error {
                        self?.view.makeToast(theError.localizedDescription)
                    } else {
                        self?.view.makeToast("Request sent.")
                    }
                })
            } else if segmentControl.selectedSegmentIndex == 1 {
                Lava.exitVirtualBeaconRegion(completion: { [weak self] (error) -> Void in
                    if let theError = error {
                        self?.view.makeToast(theError.localizedDescription)
                    } else {
                        self?.view.makeToast("Request sent.")
                    }
                })
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case AreaType.Beacon.hashValue:
            return AreaManager.sharedManager.activeBeaconAreas.count
        case AreaType.Circular.hashValue:
            return AreaManager.sharedManager.activeCircularAreas.count
        case AreaType.Gimbal.hashValue:
            return AreaManager.sharedManager.activeGimbalAreas.count
        default :
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case AreaType.Beacon.hashValue:
            return AreaType.Beacon.rawValue
        case AreaType.Circular.hashValue:
            return AreaType.Circular.rawValue
        case AreaType.Gimbal.hashValue:
            return AreaType.Gimbal.rawValue
        default :
            return ""
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeaconTableViewCell", for: indexPath) as! BeaconTableViewCell
        switch indexPath.section {
        case AreaType.Beacon.hashValue :
            if let beaconRegions: [CLBeacon] = AreaManager.sharedManager.activeBeaconAreas, beaconRegions.count > 0 , let beaconRegion: CLBeacon = beaconRegions[indexPath.row] {
                cell.beacon = beaconRegion
            }
        case AreaType.Circular.hashValue :
            if let circularRegions: [CLCircularRegion] = AreaManager.sharedManager.activeCircularAreas, circularRegions.count > 0, let circular: CLCircularRegion =  circularRegions[indexPath.row] {
                cell.circularRegion = circular
            }
        case AreaType.Gimbal.hashValue :
            if let gimbalRegions: [GMBLVisit] = AreaManager.sharedManager.activeGimbalAreas, gimbalRegions.count > 0, let gimbalVisit: GMBLVisit = gimbalRegions[indexPath.row] {
                cell.gimbalVisit = gimbalVisit
            }
        default : return cell
        }
        cell.setLabelText()
        return cell
    }
    
    func RefreshBeaconList() {
        self.beaconTableView.reloadData()
    }
    
}



