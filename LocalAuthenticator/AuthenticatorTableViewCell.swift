//
//  AuthenticatorTableViewCell.swift
//  LocalAuthenticator
//
//  Created by Темирлан Алпысбаев on 6/27/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import UIKit
import OneTimePassword
import Base32

class AuthenticatorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    
    var account: Account?
    var isUpdating: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateProgress() {
        isUpdating = true
        
        if let account = self.account {
            createToken(account: account)
            perform(#selector(startUpdating), with: nil, afterDelay: 0.0)
        }
    }
    
    func startUpdating() {
        perform(#selector(updateProgress), with: 30, afterDelay: 30)
    }

    func createToken(account: Account) {
        guard let secretData = MF_Base32Codec.data(fromBase32String: account.secret),
            !secretData.isEmpty else {
                print("Invalid secret")
                return
        }
        
        guard let generator = Generator(
            factor: .timer(period: 30),
            secret: secretData,
            algorithm: .sha1,
            digits: 6) else {
                print("Invalid generator parameters")
                return
        }
        
        let token = Token(name: String(describing: account.name!), issuer: account.issuer!, generator: generator)
        
        perform(#selector(updateToken(token:)), with: token.currentPassword!, afterDelay: 30)
    }
    
    func updateToken(token: String) {
        numberLabel.text = token
    }
    
}
