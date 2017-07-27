//
//  LocalAuthenticatorTests.swift
//  LocalAuthenticatorTests
//
//  Created by Темирлан Алпысбаев on 7/25/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import XCTest

@testable import LocalAuthenticator
@testable import OneTimePassword

class LocalAuthenticatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCipher() {
        let testString = "abcd efgh ijkl mnop"
        
        guard let encodedString = Cipher.encodedString(origin: testString) else {
            XCTFail("Fail encoding")
            return
        }
        
        guard let decodedString = Cipher.decodedString(encoded: encodedString) else {
            XCTFail("Fail decoding")
            return
        }
        
        XCTAssertEqual(testString, decodedString, "Original string and encoded-decoded string are not equal")
    }
    
    func testIfTokenCanBeCreated() {
        var key = ""
        
        for _ in 0...50 {
            key += "a"
            
            if !TokenGenerator.canCreateToken(secretKey: key) {
                XCTFail("Cannot craete token on key: \(key)")
            }
        }
    }
    
    func testTokenGeneration() {
        guard let token = TokenGenerator.createToken(issuer: "TestIssuer", name: "TestName", secret: Cipher.encodedString(origin: "abcd efgh ijkl mnop")!) else {
            XCTFail("Error creating token1")
            return
        }
        
        guard let password = token.currentPassword, password.characters.count == 6 else {
            XCTFail("Incorrect password created")
            return
        }
        
        guard token.generator.algorithm == .sha1 else {
            XCTFail("Incorrect algorithm")
            return
        }
    }
    
    func testTokenUpdate() {
        let timeInterval = 30.0
        
        guard let token1 = TokenGenerator.createToken(issuer: "TestIssuer", name: "TestName", secret: Cipher.encodedString(origin: "abcd efgh ijkl mnop")!) else {
            XCTFail("Error creating token1")
            return
        }
        
        let token1Password = token1.currentPassword
        RunLoop.current.run(until: Date(timeInterval: timeInterval, since: Date()))
        let token2Password = token1.updatedToken().currentPassword
        
        if token1Password == token2Password {
            XCTFail("Tokens should be regenerated every 30 seconds according to system time")
        }
    }
    
    func testCoreDataStack() {
        let numberOfIterations = 10
        
        if let accounts = CoreDataStack.shared.getAccounts() {
            let initialNumberOfObjects = accounts.count
            
            for _ in 0...numberOfIterations - 1 {
                CoreDataStack.shared.save(issuer: "Test Issuer", name: "Test Name", secret: "abcd efgh ijkl mnop")
            }
            
            guard let testAccounts = CoreDataStack.shared.getAccounts() else {
                XCTFail("Cannot get accounts from CoreData")
                return
            }
            
            for testAccount in testAccounts {
                if !accounts.contains(testAccount) {
                    CoreDataStack.shared.remove(account: testAccount)
                }
            }
            
            XCTAssertEqual(testAccounts.count - numberOfIterations, initialNumberOfObjects, "Incorrect saving-retrieving objects in CoreData")
        }
    }
    
}
