//
//  CodeViewController.swift
//  VerifyExampleSW
//
//  Created by Sergey P on 02.10.17.
//  Copyright © 2017 Sergey Popov. All rights reserved.
//

import UIKit


class CodeViewController: UIViewController {

    @IBOutlet weak var codeField: UITextField!
    
    @IBAction func actionCheck(_ sender: Any)
    {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            
            delegate.verifire?.confirm(withCode: self.codeField.text!, completion: { (requestId, phone, error) in
                
                if let err = error as NSError? {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.show(alert, sender: sender)
                } else {
                    
                    self.performSegue(withIdentifier: "SuccessSegue", sender: nil)
                }
                
            })
        }
    }
}
