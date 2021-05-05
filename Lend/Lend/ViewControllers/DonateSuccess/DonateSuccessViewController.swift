//
//  DonateSuccessViewController.swift
//  Lend
//
//  Created by ОК on 21.01.2021.
//

import UIKit

class DonateSuccessViewController: UIViewController {
    
    @IBOutlet weak var toOrganisationNameLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tipsToLendLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    var donateAmount: Int = 0
    var tipsAmount: Int = 0
    var isOneTimeMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addGradiant(colors: [UIColor(named: "blue")!.cgColor, UIColor(named: "gradientGreen")!.cgColor])
        shareButton.layer.cornerRadius = 0.5 * shareButton.bounds.height
        
        imageView.image = nil
        amountLabel.text = "$\(donateAmount)"
        toOrganisationNameLabel.text = ""//todo: //check???
        
        if tipsAmount > 0 {
            tipsToLendLabel.text =  isOneTimeMode ? "Plus $\(tipsAmount) to Lend" : "Plus $\(tipsAmount)/month to Lend"
        } else {
            tipsToLendLabel.text = ""
        }
        
        periodLabel.text = isOneTimeMode ? " One Time" : "/month"
    }
    
    func shareApp() {
        let activityVC = UIActivityViewController(activityItems: [Constants.Link.appstore], applicationActivities: nil)
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }

        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        shareApp()
    }
    
    @IBAction func backToHomeButtonPressed(_ sender: Any) {
        guard let rootTB = Coordinator.rootTabbar else { return }
        
        let homeNC = rootTB.viewControllers[rootTB.selectedIndex] as? UINavigationController
        homeNC?.popToRootViewController(animated: false)
        homeNC?.viewControllers.first?.dismiss(animated: true, completion: nil)
    }
}
