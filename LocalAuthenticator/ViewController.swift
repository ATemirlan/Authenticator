//
//  ViewController.swift
//  LocalAuthenticator
//
//  Created by Темирлан Алпысбаев on 6/27/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import UIKit
import OneTimePassword
import Base32

class ViewController: UIViewController {

    @IBOutlet weak var rightBar: UIProgressView!
    @IBOutlet weak var leftBar: UIProgressView!
    
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var accounts = [Account]()
    
    var currentTime: Float!
    var currentProgress: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setup()
        
        startProgressAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopProgressAnimation()
    }
    
    func getCurrentTime() -> Float {
        let formatter = DateFormatter()
        formatter.dateFormat = "ss"
        let second = Float(formatter.string(from: Date()))!
        return second < 30.0 ? second : second - 30.0
    }
    
    func stopProgressAnimation() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    func startProgressAnimation() {
        currentTime = getCurrentTime()
        currentProgress = currentTime / 30.0
        
        leftBar.setProgress(currentProgress, animated: false)
        rightBar.setProgress(1.0 - currentProgress, animated: false)
        
        tableView.reloadData()
        perform(#selector(updateProgress), with: nil, afterDelay: 0.0)
    }
    
    func updateProgress() {
        UIView.animate(withDuration: TimeInterval(exactly: 30.0 - currentTime)!, animations: {
            self.leftBar.setProgress(1.0, animated: true)
            self.rightBar.setProgress(0.0, animated: true)
        }) { (completion) in
            self.perform(#selector(self.startProgressAnimation), with: nil, afterDelay: TimeInterval(exactly: 30.0 - self.currentTime)!)
        }
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: tableView.isEditing ? .done : .edit, target: self, action: #selector(edit(_:)))
    }
    
    func setup() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        tableView.tableFooterView = UIView()
        
        if let accs = CoreDataStack.shared.getAccounts() {
            accounts = accs
            print(accounts)
        }
        
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authenticatorCell")! as! AuthenticatorTableViewCell
        
        if accounts.count >= indexPath.row {
            let account = accounts[indexPath.row]
            cell.accountLabel.text = account.name!
            cell.account = account
            cell.numberLabel.text = createToken(account: account)?.currentPassword!
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16.0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction.init(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: { (action, path) in
            CoreDataStack.shared.remove(account: self.accounts.remove(at: indexPath.row))
            tableView.reloadData()
        })]
    }
    
    func createToken(account: Account) -> Token? {
        guard let secretData = MF_Base32Codec.data(fromBase32String: account.secret),
            !secretData.isEmpty else {
                print("Invalid secret")
                return nil
        }
        
        guard let generator = Generator(
            factor: .timer(period: 30),
            secret: secretData,
            algorithm: .sha1,
            digits: 6) else {
                print("Invalid generator parameters")
                return nil
        }
        
        return Token(name: String(describing: account.name!), issuer: account.issuer!, generator: generator)
    }
    
}
