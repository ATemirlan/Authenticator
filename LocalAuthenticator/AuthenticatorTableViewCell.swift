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
    @IBOutlet weak var issuerLabel: UILabel!
    
    var isUpdating: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
