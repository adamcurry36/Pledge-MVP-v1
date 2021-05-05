//
//  EarnedBadgeViewController.swift
//  Lend
//
//  Created by ОК on 10.04.2021.
//

import UIKit

class EarnedBadgeViewController: UIViewController {
    
    @IBOutlet weak var continueButton: RoundedButtonWithShadow!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.cornerRadius = continueButton.bounds.height
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        Coordinator.presentRoot(from: self)
    }
}
