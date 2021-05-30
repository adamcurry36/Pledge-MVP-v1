//
//  ChooseRecipientsViewController.swift
//  Lend
//
//  Created by ОК on 01.05.2021.
//

import UIKit

class ChooseRecipientsViewController: UIViewController {
    
    @IBOutlet weak var createButton: UIButton!
    
    var organisationOrCause: Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.layer.cornerRadius = 0.5 * createButton.bounds.height
    }
    
    func showBacket() {
        let vc = Coordinator.instantiateMyBucketVC()
        if let cause = organisationOrCause as? Cause {
            vc.cause = cause
        }
        if let organisation = organisationOrCause as? OrganisationItem {
            vc.organizations = [organisation]
        }
        
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func createButtonPressed(_ sender: Any) {
        showBacket()
    }
}
