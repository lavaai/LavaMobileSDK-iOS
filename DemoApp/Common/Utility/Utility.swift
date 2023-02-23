//
//  Utility.swift
//  DemoApp1
//
//  Created by rohith on 21/01/16.
//

import UIKit

class Utility: NSObject {
    
    class func appVersion() -> String {
        var version = ""
        if let dict = Bundle.main.infoDictionary {
            if let versionString = dict["CFBundleShortVersionString"], let bundleVersion = dict["CFBundleVersion"] as? String {
                version = "V\(versionString)(\(bundleVersion))"
            }
        }
        return version
    }
    class func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    class func isValidPhoneNumber(_ testStr:String) -> Bool {
        let phoneNumberRegEx =  "^\\+(?:[0-9] ?){6,14}[0-9]$"
        let range = testStr.range(of: phoneNumberRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    class func isOnlyNumbers(_ testStr:String) -> Bool{
        let phoneNumberRegEx =  "^[0-9]{6,14}$"
        let range = testStr.range(of: phoneNumberRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    @discardableResult class func showAlert(
        _ controller: UIViewController,
        title: String,
        message: String,
        leftTitle: String?,
        rightTitle: String?,
        completionHandler: ((UIAlertAction) -> Void)?
    ) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        if leftTitle != nil {
            let leftAction = UIAlertAction(title: leftTitle!, style: .default, handler: { (alert: UIAlertAction) -> Void in
                completionHandler?(alert)
            })
            alertController.addAction(leftAction)
        }
        
        if rightTitle != nil {
            let rightAction = UIAlertAction(title: rightTitle!, style: .default, handler: { (alert: UIAlertAction) -> Void in
                completionHandler?(alert)
            })
            alertController.addAction(rightAction)
        }
        
        if (controller.isKind(of: UINavigationController.self)) {
            controller.present(
                alertController,
                animated: true,
                completion: nil
            )
        } else if let currentNavigation = controller.navigationController {
            currentNavigation.present(
                alertController,
                animated: true,
                completion: nil
            )
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let navController = appDelegate.window!.rootViewController as! UINavigationController
            navController.present(
                alertController,
                animated: true,
                completion: nil
            )
        }
        return alertController
    }
    
    class func parentController(
        _ parentController: UIViewController,
        withContainer containerView: UIView,
        withChildController childController: UIViewController,
        withFrameWidth width: NSInteger,
        align: ViewAlignType
    ) {
        parentController.addChild(childController)
        let frame = containerView.bounds;
        childController.view.frame = frame
        containerView.addSubview(childController.view)
        childController.didMove(toParent: parentController);
        let childView:UIView = childController.view;
        
        let parentView:UIView = containerView;
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        parentView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelssDictionary =  ["childView":childView,"parentView":parentView]
        
        var c1:[NSLayoutConstraint]?
        switch (align.rawValue)
        {
        case ViewAlignType.alignCenter.rawValue :
            c1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[childView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: labelssDictionary)
            break
        case ViewAlignType.alignLeft.rawValue :
            c1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[childView(\(width))]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: labelssDictionary)
            break
        case ViewAlignType.alignRight.rawValue :
            c1 = NSLayoutConstraint.constraints(withVisualFormat: "H:[childView(\(width))]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: labelssDictionary)
            break
        default :
            c1 = nil
            
        }
        let c2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[childView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: labelssDictionary)
        
        parentView.addConstraints(c1!)
        parentView.addConstraints(c2)
    }
    
    class func removeChildController(_ childController: UIViewController,fromParentController parentController: UIViewController, fromContainerView containerView: UIView) -> Void {
        childController.willMove(toParent: nil)
        let containerConstraints: Array =  containerView.constraints
        unowned let childView: UIView = childController.view
        let l_predicate: NSPredicate = NSPredicate {
            (evaluatedObject, bindings) -> Bool in
            let l_array = evaluatedObject as? [UIView]
            return l_array?.first === childView
        }
        let l_constraints: Array = containerConstraints.filter { l_predicate.evaluate(with: $0) }
        containerView.removeConstraints(l_constraints)
        childView.removeFromSuperview()
        childController.removeFromParent()
    }
    
}
