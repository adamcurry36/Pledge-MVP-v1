//
//  ChooseRecipientsViewController.swift
//  Lend
//
//  Created by ОК on 01.05.2021.
//

import UIKit

class ChooseRecipientsViewController: UIViewController {
    
    @IBOutlet weak var createButton: UIButton!
    
    var cause: Cause!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.layer.cornerRadius = 0.5 * createButton.bounds.height
    }
    
    func showBacket() {
        let vc = Coordinator.instantiateMyBucketVC()
        vc.cause = cause
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func createButtonPressed(_ sender: Any) {
        showBacket()
    }
}
