//
//  AddAccountViewController.swift
//  LocalAuthenticator
//
//  Created by Темирлан Алпысбаев on 6/29/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import UIKit

class AddAccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    let accountInfo = ["Account" : "user@example.com", "Key" : "abcd efgh ijkl mnop"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addAccount(_ sender: UIButton) {
    }
    
}

extension AddAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

extension AddAccountViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addAccountCell") as! AddAccountTableViewCell
        
        cell.titleLabel.text = Array(accountInfo.keys)[indexPath.section]
        cell.textField.placeholder = Array(accountInfo.values)[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 16.0
    }
    
}
