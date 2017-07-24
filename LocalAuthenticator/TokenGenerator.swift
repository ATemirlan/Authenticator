//
//  Utils.swift
//  LocalAuthenticator
//
//  Created by Темирлан Алпысбаев on 7/24/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import Foundation
import OneTimePassword
import Base32

class TokenGenerator {

    static func canCreateToken(secretKey: String) -> Bool {
        guard let data = secretData(secret: secretKey) else {
            return false
        }
        
        guard let _ = generator(data: data) else {
            return false
        }
        
        return true
    }
    
    static func createToken(account: Account) -> Token? {
        guard let decodedSecret = Cipher.decodedString(encoded: account.secret!) else {
            return nil
        }
        
        guard canCreateToken(secretKey: decodedSecret) else {
            return nil
        }
        
        return Token(name: String(describing: account.name!),
                   issuer: account.issuer!,
                generator: generator(data: secretData(secret: decodedSecret)!)!)
    }
    
    private static func generator(data: Data) -> Generator? {
        guard let generator = Generator(
            factor: .timer(period: 30),
            secret: data,
            algorithm: .sha1,
            digits: 6) else {
                print("Invalid generator parameters")
                return nil
        }
        
        return generator
    }
    
    private static func secretData(secret: String) -> Data? {
        guard let secretData = MF_Base32Codec.data(fromBase32String: secret),
            !secretData.isEmpty else {
                print("Invalid secret")
                return nil
        }
        
        return secretData
    }
    
}
