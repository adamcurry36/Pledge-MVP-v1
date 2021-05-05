//
//  LetsGoGreaterViewController.swift
//  Lend
//
//  Created by ОК on 09.04.2021.
//

import UIKit

class LetsGoGreaterViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.layer.cornerRadius = 0.5 * continueButton.bounds.height
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let vc = Coordinator.instantiateEarnedBadgeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
