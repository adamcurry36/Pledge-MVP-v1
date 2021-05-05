//
//  AdjustDonateAmountViewController.swift
//  Lend
//
//  Created by ОК on 12.04.2021.
//

import UIKit

class AdjustDonateAmountViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var donateAmountLabel: UILabel!
    @IBOutlet weak var regualaryLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var maxDonateValueLabel: UILabel!
    
    var donateAmount: Int = 0
    var isOneTimePaymentMode: Bool = false
    var causeOrOrganisationToPayOneTime: Any?
    var onContinueAction: ((Int)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regualaryLabel.text = isOneTimePaymentMode ? "One Time" : "/monthly"
        slider.minimumValue = Float(Constants.minAmount)
        slider.maximumValue = Float(Constants.maxCauseAmount)
        slider.value = Float(donateAmount)
        slider.setThumbImage(UIImage(named: "SliderThumb"), for: .normal)
        
        maxDonateValueLabel.text = "$\(Constants.maxCauseAmount)"
        continueButton.layer.cornerRadius = 0.5 * continueButton.bounds.height
        updateUI()
    }
    
    func updateUI() {
        donateAmountLabel.text = "$\(donateAmount)"
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if causeOrOrganisationToPayOneTime != nil {
            UserManager.shared.oneTimeDonateAmout = Int(slider.value)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if isOneTimePaymentMode {
            UserManager.shared.oneTimeDonateAmout = Int(slider.value)
        }
        
        if causeOrOrganisationToPayOneTime != nil {
            UserManager.shared.oneTimeDonateAmout = donateAmount
            let vc = Coordinator.instantiateMyBucketVC()
            vc.isOneTimePaymentMode = true
            if let cause = causeOrOrganisationToPayOneTime as? Cause {
                vc.cause = cause
            } else if let org = causeOrOrganisationToPayOneTime as? OrganisationItem {
                 //todo:
            }
            navigationController?.pushViewController(vc, animated: true)
        } else {
            self.onContinueAction?(donateAmount)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        donateAmount = Int(slider.value)
        updateUI()
    }
}
