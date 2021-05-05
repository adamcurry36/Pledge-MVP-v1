//
//  OurTransparencyViewController.swift
//  Lend
//
//  Created by ОК on 06.03.2021.
//

import UIKit


class OurTransparencyViewController: UIViewController {
    
    @IBOutlet weak var topBarTopConstaint: NSLayoutConstraint!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        topBarTopConstaint.constant = safeAreaInsets.top == 0 ? 0 : 30
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
