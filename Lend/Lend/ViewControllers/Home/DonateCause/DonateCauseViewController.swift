//
//  DonateCauseViewController.swift
//  Lend
//
//  Created by ОК on 30.03.2021.
//

import UIKit

class DonateCauseViewController: UIViewController {
    
    @IBOutlet weak var continueButton: RoundedButtonWithShadow!
    @IBOutlet weak var donateAmountLabel: UILabel!
    @IBOutlet weak var regualaryLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var maxDonateValueLabel: UILabel!
    
    var cause: Cause!
    var donateAmount: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        regualaryLabel.text = cause.regulary ? "/monthly" : "one time"
        slider.minimumValue = Float(Constants.minAmount)
        slider.maximumValue = Float(Constants.maxCauseAmount)
        slider.value = Float(donateAmount)
        slider.setThumbImage(UIImage(named: "SliderThumb"), for: .normal)
        maxDonateValueLabel.text = "$\(Constants.maxCauseAmount)"
        continueButton.cornerRadius = continueButton.bounds.height
        updateUI()
    }
    
    func updateUI() {
        donateAmountLabel.text = "$\(donateAmount)"
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        UserManager.shared.tmpDonateAmount = donateAmount
        let vc = Coordinator.instantiateMyBucketVC()
        vc.cause = cause
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        donateAmount = Int(slider.value)
        updateUI()
    }
}
