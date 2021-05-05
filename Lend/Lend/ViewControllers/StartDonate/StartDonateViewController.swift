//
//  StartDonateViewController.swift
//  Lend
//
//  Created by ОК on 09.04.2021.
//

import UIKit

class StartDonateViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var donateAmountLabel: UILabel!
    @IBOutlet weak var regualaryLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var maxDonateValueLabel: UILabel!
    @IBOutlet weak var seeOrganisationsButton: UIButton!
    
    var donateAmount: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        regualaryLabel.text = "/monthly"
        slider.minimumValue = Float(Constants.minAmount)
        slider.maximumValue = Float(Constants.maxCauseAmount)
        slider.value = Float(donateAmount)
        slider.setThumbImage(UIImage(named: "SliderThumb"), for: .normal)
        maxDonateValueLabel.text = "$\(Constants.maxCauseAmount)"
        continueButton.layer.cornerRadius = 0.5 * continueButton.bounds.height
        seeOrganisationsButton.setUndlinedTitle()
        updateUI()
    }
    
    func updateUI() {
        donateAmountLabel.text = "$\(donateAmount)"
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        FirestoreManager.shared.updateDefaultDonateAmount(donateAmount) { _ in }
        UserManager.shared.user?.defaultDonateAmount = donateAmount
        let vc = UIStoryboard(name: donateAmount > 6 ? "LetsGoGreater" : "LetsGo", bundle: nil).instantiateInitialViewController()!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        donateAmount = Int(slider.value)
        updateUI()
    }
    
    @IBAction func seeOrganisationsButtonPressed(_ sender: Any) {
        Coordinator.presentRoot(from: self)
    }
}
