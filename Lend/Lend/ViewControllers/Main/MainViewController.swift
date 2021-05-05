//
//  MainViewController.swift
//  Lend
//
//  Created by ОК on 06.01.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !Coordinator.onboardingFinished {
            Coordinator.presentOnboarding(from: self)
        } else {
            FirestoreManager.shared.checkAuth { isAuthorized in
                if isAuthorized {
                    Coordinator.redirectToRoot()
                } else {
                    Coordinator.redirectToAuth()
                }
            }
        }
    }
}

