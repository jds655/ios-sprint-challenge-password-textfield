//
//  ViewController.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/25/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

@IBDesignable
class ViewController: UIViewController {
    
    @IBOutlet weak var passwordField: PasswordField!
    // For use in the stretch goal
    //
    // Uncomment this entire method, then run the app.
    // A dictionary view should appear, with a "manage" button
    // in the lower left corner. Tap that button and choose a dictionary
    // to install (you can use the first one "American English"). Tap
    // the little cloud download button to install it. Then just stop the app
    // and comment this method out again. This step only needs to run once.
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordField.bgColor = UIColor(red: 104/255, green: 0/255, blue: 178/255, alpha: 1.0)
        passwordField.delegate = self
        // Uncomment this portion to set up the dictionary
//        let str = "lambda"
//        let referenceVC = UIReferenceLibraryViewController(term: str)
//        present(referenceVC, animated: true, completion: nil)
    }
}

extension ViewController:PasswordFieldDelegate {
    func passwordEntered() {
        let alert = UIAlertController(title: "Thank you", message: "PAssword entered and accepted.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            self.passwordField.isHidden = true
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
