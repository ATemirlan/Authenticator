//
//  ViewController.swift
//  LocalAuthenticator
//
//  Created by Темирлан Алпысбаев on 6/27/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rightBar: UIProgressView!
    @IBOutlet weak var leftBar: UIProgressView!
    
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var accounts = [Account?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateProgress()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: tableView.isEditing ? .done : .edit, target: self, action: #selector(edit(_:)))
    }
    
    func updateProgress() {
        leftBar.setProgress(0.0, animated: false)
        rightBar.setProgress(1.0, animated: false)
            
        perform(#selector(startUpdating), with: nil, afterDelay: 0.0)
    }
    
    func startUpdating() {
        perform(#selector(updateProgress), with: 10, afterDelay: 10)
        
        UIView.animate(withDuration: 10) {
            self.leftBar.setProgress(1.0, animated: true)
            self.rightBar.setProgress(0.0, animated: true)
        }
    }
    
    func setup() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        tableView.tableFooterView = UIView()
        accounts.append(Account(issuer: "Google", name: "google@google.com", secret: "bzbx vbhg clxt fytm tlgy k6o5 vpr6 pccj"))
        accounts.append(Account(issuer: "Twitter", name: "maill@mail.ru", secret: "bzbx vbhg clxt fytm tlgy k6o5 vpr6 pccg"))
        accounts.append(Account(issuer: "Yahoo", name: "hoyaa@yahoo.com", secret: "bzbx vbhg clxt fytm tlgy k6o5 vpr6 pcck"))
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authenticatorCell")! as! AuthenticatorTableViewCell
        
        if let account = accounts[indexPath.row] {
            cell.accountLabel.text = account.name!
            cell.account = account
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !(cell as! AuthenticatorTableViewCell).isUpdating {
            (cell as! AuthenticatorTableViewCell).updateProgress()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16.0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction.init(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: { (action, path) in
            self.accounts.remove(at: indexPath.row)
            tableView.reloadData()
        })]
    }
    
}
