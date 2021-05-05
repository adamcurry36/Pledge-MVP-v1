//
//  EditImpactViewController.swift
//  Lend
//
//  Created by ОК on 26.01.2021.
//

import UIKit

class EditImpactViewController: UIViewController {
    
    @IBOutlet weak var topBarTopConstaint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: RoundedViewWithShadow!
    @IBOutlet weak var toLendLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var donateItem: DonateItem!
    var donateAmount: Int = 0
    var tipsAmount: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        topBarTopConstaint.constant = safeAreaInsets.top == 0 ? 0 : 30
        imageView.sd_setImage(with: donateItem.organisation.imageUrl)
        nameLabel.text = donateItem.organisation.name
        filterTitleLabel.text = donateItem.organisation.filterName ?? ""
        donateAmount = donateItem.amount
        containerView.cornerRadius = 1
        containerView.shadowOffsetWidth = 0
        containerView.shadowOpacity = 0.3
        
        updateUI()
    }
    
    func updateUI() {
        textField.text = "\(donateAmount)"
        toLendLabel.text = "Plus $\(tipsAmount)/month to Pledge"
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
