//
//  ChooseAmountStepOneVC.swift
//  Lend
//
//  Created by ОК on 01.05.2021.
//

import UIKit

class ChooseAmountStepOneVC: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var donateAmountLabel: UILabel!
    @IBOutlet weak var regualaryLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var maxDonateValueLabel: UILabel!
    
    var cause: Cause!
    var donateAmount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        regualaryLabel.text = "/monthly"
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
    
    func showChooseRecipients() {
        let vc = Coordinator.instantiateChooseRecipientsVC()
        vc.cause = cause
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        view.startActivityAnimating()
        FirestoreManager.shared.updateDefaultDonateAmount(donateAmount) { [weak self] success in
            guard let self = self else { return }
            
            self.view.stopActivityAnimating()
            if success {
                self.showChooseRecipients()
            } else {
                self.showAlert(message: Constants.Error.unexpectedError, type: .error)
            }
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        donateAmount = Int(slider.value)
        updateUI()
    }

}
