//
//  RoundedView.swift
//  DemoApp
//
//  Created by Thuong Nguyen on 29/11/2021.
//  Copyright © 2021 CodeCraft Technologies. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
    }

}
