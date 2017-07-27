//
//  BaseTests.swift
//  LocalAuthenticator
//
//  Created by Темирлан Алпысбаев on 7/27/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import KIF

// Not a tests
class BaseTests: KIFTestCase {
    
    let fields = ["issuerField", "accountField", "keyField"]
    
    func tapButton(_ button: String) {
        tester().tapView(withAccessibilityLabel: button)
    }
    
    func clearField(_ field: String) {
        tester().clearTextFromView(withAccessibilityLabel: field)
    }
    
    func fill(_ field: String, with text: String) {
        tester().setText(text, intoViewWithAccessibilityLabel: field)
    }
    
    func addAccount(with data: [String]) {
        tapButton("addButton")
        clearAllFields()
        fillAllFields(with: data)
        tapButton("addAccountButton")
    }
    
    func fillAllFields(with data: [String]) {
        for i in 0...2 {
            fill(fields[i], with: data[i])
        }
    }
    
    func clearAllFields() {
        for field in fields {
            clearField(field)
        }
    }
    
}
