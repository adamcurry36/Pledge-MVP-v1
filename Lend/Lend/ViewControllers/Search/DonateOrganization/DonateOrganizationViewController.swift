//
//  DonateOrganizationViewController.swift
//  Lend
//
//  Created by ОК on 02.04.2021.
//

import UIKit

class DonateOrganizationViewController: UIViewController {
    
    @IBOutlet weak var donateButton: RoundedButtonWithShadow!
    @IBOutlet weak var donateAmountLabel: UILabel!
    @IBOutlet weak var regualaryLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var maxDonateValueLabel: UILabel!
    
    var organization: OrganisationItem!
    var donateAmount: Int = 5
    private var paymentManager: PaymentManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        regualaryLabel.text = "/monthly"
        slider.minimumValue = Float(Constants.minAmount)
        slider.maximumValue = Float(Constants.maxAmount)
        slider.value = Float(donateAmount)
        slider.setThumbImage(UIImage(named: "SliderThumb"), for: .normal)
        maxDonateValueLabel.text = "$\(Constants.maxAmount)"
        donateButton.cornerRadius = donateButton.bounds.height
        updateUI()
    }
    
    func updateUI() {
        donateAmountLabel.text = "$\(donateAmount)"
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func donateButtonPressed(_ sender: Any) {
        UserManager.shared.tmpDonateAmount = donateAmount
        let vc = Coordinator.instantiateMyBucketVC()
        vc.organizations = [organization]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        donateAmount = Int(slider.value)
        updateUI()
    }
}

