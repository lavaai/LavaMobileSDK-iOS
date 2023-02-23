//
//  Constants.swift
//  DemoApp
//
//  Created by rohith on 20/01/16.
//

import Foundation

public typealias completionBlock = () -> Void

// TODO: Update this BaseURL when you need to call your app backend
public let AppBackendBaseURL = "https://gcp2dev-sdk-sample-app-backend.test.lava.ai"


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
