//
//  EditableViewController.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 29/11/2021.
//

import UIKit

class EditableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
        view.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        guard let editableView = getEditableView() else {
            return
        }
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let maxY: CGFloat = editableView.frame.maxY
        let totalHeight: CGFloat = self.view.frame.height
        let diff: CGFloat = totalHeight - maxY
        let keyBoardHeight: CGFloat = keyboardFrame.height
        if diff < keyBoardHeight {
            if notification.name == UIResponder.keyboardDidShowNotification {
                let offsetY: CGFloat = keyBoardHeight - diff
                UIView.animate(
                    withDuration: 0.3,
                    animations: { [weak editableView] () -> Void in
                        editableView?.transform.ty = -offsetY
                    },
                    completion: nil
                )
            }
        }
    }
    
    @objc func keyboardWillHide(notification : NSNotification) {
        guard let editableView = getEditableView() else {
            return
        }
        
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak editableView] () -> Void in
                editableView?.transform.ty = 0
            },
            completion: nil
        )
    }
    
    open func getEditableView() -> UIView? {
        return nil
    }

}
