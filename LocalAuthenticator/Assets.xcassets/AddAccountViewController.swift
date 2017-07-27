//
//  AddAccountViewController.swift
//  LocalAuthenticator
//
//  Created by Темирлан Алпысбаев on 6/29/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class AddAccountViewController: UIViewController {
    
    @IBOutlet var fields: [UITextField]!
    @IBOutlet weak var backItem: UIBarButtonItem!

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func addAccount(_ sender: UIButton) {
        if let key = fields[2].text, key.characters.count > 0, TokenGenerator.canCreateToken(secretKey: key) {
            CoreDataStack.shared.save(issuer: fields[0].text, name: fields[1].text, secret: key)
            Utils.showSuccessAlert(message: "Account added", at: self)
        } else {
            Utils.showErrorAlert(message: fields[2].text!.characters.count > 0 ? "Incorrect key" : "Key must not be empty", at: self)
        }
    }
    
    @IBAction func scanAccount(_ sender: UIBarButtonItem) {
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.authorized {
            showReader()
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted: Bool) -> Void in
                if granted {
                    self.showReader()
                }
            })
        }
    }
    
    func showReader() {
        readerVC.delegate = self
        readerVC.modalPresentationStyle = .formSheet
        setupCameraCancelAccessibility()
        present(readerVC, animated: true, completion: nil)
    }
    
    func setupCameraCancelAccessibility() {
        for v in readerVC.view.subviews[0].subviews {
            if v is UIButton, (v as! UIButton).titleLabel?.text == "Cancel" {
                (v as! UIButton).accessibilityLabel = "cancelButton"
            }
        }
    }
    
}

extension AddAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

extension AddAccountViewController: QRCodeReaderViewControllerDelegate {
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        dismiss(animated: true) {
            if let url = URL(string: result.value) {
                let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
                
                if let queryItems = components.queryItems {
                    for item in queryItems {
                        DispatchQueue.main.async {
                            switch item.name {
                            case "secret":
                                self.fields[2].text = item.value!
                                break
                            case "issuer":
                                self.fields[0].text = item.value!
                                break
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
}
