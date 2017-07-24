//
//  Cipher.swift
//  LocalAuthenticator
//
//  Created by Темирлан Алпысбаев on 7/24/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import Foundation
import RNCryptor

class Cipher {
    
    private static let password = "LocalPassword"
    
    static func encodedString(origin: String) -> String? {
        let encryptor = RNCryptor.Encryptor(password: password)
        let ciphertext = NSMutableData()
        
        let base64Str = toBase64(origin)
        
        guard let data = Data(base64Encoded: base64Str) else {
            return nil
        }
        
        ciphertext.append(encryptor.update(withData: data))
        ciphertext.append(encryptor.finalData())
        
        return ciphertext.base64EncodedString(options: [])
    }
    
    static func decodedString(encoded: String) -> String? {
        let decryptor = RNCryptor.Decryptor(password: password)
        let plaintext = NSMutableData()
        
        guard let data = Data(base64Encoded: encoded) else {
            return nil
        }
        
        try! plaintext.append(decryptor.update(withData: data))
        try! plaintext.append(decryptor.finalData())
        
        return fromBase64(plaintext.base64EncodedString(options: []))
    }
    
    private static func fromBase64(_ str: String) -> String? {
        guard let data = Data(base64Encoded: str) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    private static func toBase64(_ str: String) -> String {
        return Data(str.utf8).base64EncodedString()
    }
    
}
