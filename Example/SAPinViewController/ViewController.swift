//
//  ViewController.swift
//  SAPinViewController
//
//  Created by Siavash on 08/21/2016.
//  Copyright (c) 2016 Siavash. All rights reserved.
//

import UIKit
import SAPinViewController

class ViewController: UIViewController {

    @IBOutlet weak var pinTextField: UITextField!
    fileprivate var pinString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(dismissGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helpers
    func dismissKeyboard() {
         view.endEditing(true)
         pinString = pinTextField.text ?? ""

    }
    
    func canShowPIN() -> Bool {
        return pinString.characters.count == 4
    }
    
    func showAlertViewWithMessage(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Retry", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    // MARK: Actions
    @IBAction func setPinTap(_ sender: UIButton) {
        view.endEditing(true)
        if !canShowPIN() {
            showAlertViewWithMessage("PIN should be 4-digit!")
        }
    }
    
    @IBAction func lockTap(_ sender: UIButton) {
        if canShowPIN() {
            // initial a `SAPinViewController` via the designate initialiser
            let pinVC = SAPinViewController(withDelegate: self, backgroundImage: UIImage(named: "bg3"), backgroundColor: nil, logoImage: UIImage(named: "logo"))
            // setup different properties
            pinVC.subtitleText = "Your passcode is required to enable Touch ID"
            pinVC.buttonBorderColor = UIColor(red: 209/255.0, green: 9/255.0, blue: 146/255.0, alpha: 1.0)
            pinVC.alphabetColor = UIColor.orange
            pinVC.numberColor = UIColor.yellow
            pinVC.cancelButtonColor = UIColor.red
            pinVC.isRoundedRect = true
            // ... and other properties
            // present it
            present(pinVC, animated: true, completion: nil)
        } else {
            showAlertViewWithMessage("Please set a 4-digit PIN first")
        }

    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (range.location >= 4) {
            return false
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        pinString = textField.text ?? ""
    }
}

extension ViewController: SAPinViewControllerDelegate {
    func pinEntryWasCancelled() {
        dismiss(animated: true, completion: nil)
    }
    func pinEntryWasSuccessful() {
        dismiss(animated: true, completion: nil)
    }
    func pinWasIncorrect() {

    }
    func isPinValid(_ pin: String) -> Bool {
        return pin == pinString
    }
}
