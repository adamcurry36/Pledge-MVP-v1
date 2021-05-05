//
//  AuthRootViewController.swift
//  Lend
//
//  Created by ОК on 09.01.2021.
//

import UIKit

class AuthRootViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: RoundedButtonWithShadow!
    @IBOutlet weak var signInButton: RoundedButtonWithShadow!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        signUpButton.cornerRadius = 10
        signInButton.cornerRadius = 10
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        Coordinator.presentSignUp(from: self)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        Coordinator.presentSignIn(from: self)
    }
    
}
