//
//  WelcomeViewController.swift
//  Lend
//
//  Created by ОК on 09.01.2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var getStartedButton: RoundedButtonWithShadow!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let displayName = UserManager.shared.user?.displayName, !displayName.isEmpty {
            welcomeLabel.text = "Welcome, \(displayName)! 👋"
        } else {
            welcomeLabel.text = "Welcome! 👋"
        }
        
        getStartedButton.cornerRadius = getStartedButton.bounds.height
    }
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        Coordinator.presentRoot(from: self)
    }
}
