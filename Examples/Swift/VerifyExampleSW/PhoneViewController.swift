//
//  ViewController.swift
//  VerifyExampleSW
//
//  Created by Sergey P on 02.10.17.
//  Copyright © 2017 Sergey Popov. All rights reserved.
//

import UIKit
import VerifireKit

class PhoneViewController: UIViewController
{

    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: Actions
    
    @IBAction func actionGo(_ sender: Any)
    {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            
            delegate.verifire?.verifyNumber(self.phoneField.text!, method: self.selectedVerificationMethod(), completion: { (error) in
                
                if let err = error as NSError? {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.show(alert, sender: sender)
                } else {
                    
                    self.performSegue(withIdentifier: "PINSegue", sender: nil)
                }
            })
        }
    }
    
    // MARK: Private
    private func selectedVerificationMethod() -> String
    {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            return VFVerifireMethodSMS
            
        case 1:
            return VFVerifireMethodVoice
            
        default:
            return VFVerifireMethodCall
        }
    }

}

