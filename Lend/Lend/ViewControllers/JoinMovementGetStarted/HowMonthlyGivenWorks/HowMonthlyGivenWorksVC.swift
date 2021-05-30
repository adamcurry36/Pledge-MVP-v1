//
//  HowMonthlyGivenWorksVC.swift
//  Lend
//
//  Created by ОК on 29.04.2021.
//

import UIKit

class HowMonthlyGivenWorksVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var numbersViewTop: NSLayoutConstraint!
    @IBOutlet weak var labelContainer1_height: NSLayoutConstraint!
    @IBOutlet weak var labelContainer2_height: NSLayoutConstraint!
    @IBOutlet weak var labelContainer3_height: NSLayoutConstraint!
    
    var organisationOrCause: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        oneLabel.layer.cornerRadius = 0.5 * oneLabel.bounds.height
        twoLabel.layer.cornerRadius = 0.5 * oneLabel.bounds.height
        threeLabel.layer.cornerRadius = 0.5 * oneLabel.bounds.height
        continueButton.layer.cornerRadius = 0.5 * continueButton.bounds.height
        
        if UIScreen.main.bounds.height <= 658 {
            headerLabel.font = headerLabel.font.withSize(30)
            numbersViewTop.constant = 20
            labelContainer1_height.constant = 100
            labelContainer2_height.constant = 100
            labelContainer3_height.constant = 100
        } else if UIScreen.main.bounds.height <= 667 {
            headerLabel.font = headerLabel.font.withSize(34)
            numbersViewTop.constant = 25
            labelContainer1_height.constant = 120
            labelContainer2_height.constant = 120
            labelContainer3_height.constant = 100
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let vc = Coordinator.instantiateChooseAmountStepOneVC()
        vc.organisationOrCause = organisationOrCause
        navigationController?.pushViewController(vc, animated: true)
    }
}
