//
//  Constants.swift
//  DemoApp
//
//  Created by rohith on 20/01/16.
//  Copyright © 2016 CodeCraft Technologies. All rights reserved.
//

import Foundation

public typealias completionBlock = () -> Void

enum ProfileMode: Int {
    case edit = 0
    case view = 1
}

enum ViewAlignType: Int {
    case alignCenter = 0
    case alignLeft = 1
    case alignRight = 2
}

typealias UpdateBlockResponder = (_ didUpdate: Bool)-> Void
typealias CompletionHandler = () -> Void

struct ContentRequest {
    static let contentType = "content_type"
    static let url = "content_url"
}
