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
    private var pinString = ""
    
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
    
    func showAlertViewWithMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Retry", style: .Cancel, handler: { (_) in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    // MARK: Actions
    @IBAction func setPinTap(sender: UIButton) {
        view.endEditing(true)
        if !canShowPIN() {
            showAlertViewWithMessage("PIN should be 4-digit!")
        }
    }
    
    @IBAction func lockTap(sender: UIButton) {
        if canShowPIN() {
            // initial a `SAPinViewController` via the designate initialiser
            let pinVC = SAPinViewController(withDelegate: self, backgroundImage: UIImage(named: "bg3"))
            // setup different properties
            pinVC.subtitleText = "Your passcode is required to enable Touch ID"
            pinVC.buttonBorderColor = UIColor(red: 209/255.0, green: 9/255.0, blue: 146/255.0, alpha: 1.0)
            pinVC.alphabetColor = UIColor.orangeColor()
            pinVC.numberColor = UIColor.yellowColor()
            pinVC.cancelButtonColor = UIColor.redColor()
            pinVC.isRoundedRect = true
            // ... and other properties
            // present it
            presentViewController(pinVC, animated: true, completion: nil)
        } else {
            showAlertViewWithMessage("Please set a 4-digit PIN first")
        }

    }
}

extension ViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (range.location >= 4) {
            return false
        }
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        pinString = textField.text ?? ""
    }
}

extension ViewController: SAPinViewControllerDelegate {
    func pinEntryWasCancelled() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func pinEntryWasSuccessful() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func pinWasIncorrect() {

    }
    func isPinValid(pin: String) -> Bool {
        return pin == pinString
    }
}