//
//  AppSessionTests.swift
//  DemoAppTests
//

import XCTest
@testable import DemoApp

class AppSessionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetEmail() throws {
        let email = "test@test.com"
        AppSession.current.email = email
        XCTAssertEqual(AppSession.current.email, email, "Email must not be empty")
    }
    
    func testClear() throws {
        let email = "test@test.com"
        AppSession.current.email = email
        AppSession.current.clear()
        XCTAssertNil(AppSession.current.email)
    }

}
