//
//  LocalAuthenticatorUITests.swift
//  LocalAuthenticatorUITests
//
//  Created by Темирлан Алпысбаев on 7/26/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import XCTest
import AVFoundation
import KIF

class LocalAuthenticatorUITests: BaseTests {

    func testNavigation() {
        tapButton("addButton")
        
        if haveCameraAccess() {
            tapButton("qrScannerButton")
            tapButton("cancelButton")
            tapButton("backButton")
        } else {
            tapButton("backButton")
        }
    }
    
    func haveCameraAccess() -> Bool {
        return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.authorized
    }
}

class AccountAdding: BaseTests {
    
    let correctData = ["Test Issuer", "test_account@test.test", "dqw7 ewqq 1dsah jgso"]
    let emptyData = ["", "", ""]
    let incorrectData = ["Test Issuer", "test_account@test.test", "фывц 2йцу фывй"]
    
    func testWithCorrectKey() {
        addAccount(with: correctData)
        tester().waitForView(withAccessibilityLabel: "Account added")
        tapButton("OK")
    }
    
    func testWithNoKey() {
        addAccount(with: emptyData)
        tester().waitForView(withAccessibilityLabel: "Key must not be empty")
        tapButton("OK")
        tapButton("backButton")
    }
    
    func testWithIncorrectKey() {
        addAccount(with: incorrectData)
        tester().waitForView(withAccessibilityLabel: "Incorrect key")
        tapButton("OK")
        tapButton("backButton")
    }
    
}

class AccountDeleting: BaseTests {
    
    func testAccountDeleting() {
        addAccount(with: ["Google", "google@glass.com", "jfkd qwe2 dj2l oppa"])
        tapButton("OK")
        
        let tableView = tester().waitForView(withAccessibilityLabel: "tableView") as! UITableView
        let indexPath = IndexPath(row: 0, section: 0)
        tester().swipeRow(at: indexPath, in: tableView, in: .left)
        tapButton("Delete")
    }
    
}
