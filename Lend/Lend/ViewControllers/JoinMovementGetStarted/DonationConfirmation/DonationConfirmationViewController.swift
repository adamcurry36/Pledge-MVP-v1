//
//  DonationConfirmationViewController.swift
//  Lend
//
//  Created by ОК on 29.04.2021.
//

import UIKit

class DonationConfirmationViewController: UIViewController {
    
    @IBOutlet weak var getStartedButton: RoundedButtonWithShadow!
    
    var organisationOrCause: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGradiant(colors: [UIColor(named: "blue")!.cgColor, UIColor(named: "gradientGreen")!.cgColor])
        getStartedButton.cornerRadius = 0.5 * getStartedButton.bounds.height
    }
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        let vc = Coordinator.instantiateHowMonthlyGivenWorksVC()
        vc.organisationOrCause = organisationOrCause
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backToHomeButtonPressed(_ sender: Any) {
        guard let rootTB = Coordinator.rootTabbar else { return }
        
        let homeNC = rootTB.viewControllers[rootTB.selectedIndex] as? UINavigationController
        homeNC?.popToRootViewController(animated: false)
        homeNC?.viewControllers.first?.dismiss(animated: true, completion: nil)
    }
}
