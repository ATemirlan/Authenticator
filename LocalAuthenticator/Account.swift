//
//  Account.swift
//  LocalAuthenticator
//
//  Created by Темирлан Алпысбаев on 6/29/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import UIKit

class Account {

    var issuer: String?
    var name: String?
    var secret: String?
    
    init(issuer: String?, name: String?, secret: String?) {
        self.issuer = issuer
        self.name = name
        self.secret = secret
    }
    
}
