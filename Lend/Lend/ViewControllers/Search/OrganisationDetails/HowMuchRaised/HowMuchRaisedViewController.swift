//
//  HowMuchRaisedViewController.swift
//  Lend
//
//  Created by ОК on 06.03.2021.
//

import UIKit

class HowMuchRaisedViewController: UIViewController {

    @IBOutlet weak var topBarTopConstaint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalRaisedLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    
    var organisation: OrganisationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topBarTopConstaint.constant = safeAreaInsets.top == 0 ? 0 : 30
        view.addGradiant(colors: [AppColor.midBlue.value.cgColor, AppColor.gradientGreen.value.cgColor])
        imageView.sd_setImage(with: organisation.imageUrl)
        nameLabel.text = organisation.name
        
        totalRaisedLabel.text = "..."
        peopleLabel.text = "..."
        
        let raised: Float = 0.0 //todo:
        let people: Int = 0
        totalRaisedLabel.text = "$\(raised) USD"
        peopleLabel.text = "\(people) people"
        
        fetchDonatesForOrganisation()
    }
    
    func updateUI(donates: [DonateItemRef]) {
        var raised: Int = 0
        donates.forEach {
            raised += $0.amount
        }
        
        totalRaisedLabel.text = "$\(raised) USD"
        peopleLabel.text = "\(donates.count) people"//todo:  can one person donate one organisation many times?
    }
    
    func fetchDonatesForOrganisation() {
        view.startActivityAnimating()
        FirestoreManager.shared.fetchDonatesForOrganisation(id: organisation.id) { [weak self] data in
            guard let self = self else { return }
            
            self.view.stopActivityAnimating()
            if let donates = data {
                self.updateUI(donates: donates)
            } else {
                self.showToastAlert(message: Constants.Error.unexpectedError, type: .error)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backToProfileButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
