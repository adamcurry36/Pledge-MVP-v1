//
//  ChooseDonateOnceOrMonthlyVC.swift
//  Lend
//
//  Created by ОК on 29.04.2021.
//

import UIKit

class ChooseDonateOnceOrMonthlyVC: UIViewController {
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var onceButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    
    var onOnceAction: (()->Void)?
    var onMonthlyAction: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        infoView.layer.cornerRadius = 10
        onceButton.layer.cornerRadius = 10
        monthlyButton.layer.cornerRadius = 10
    }

    @IBAction func touchButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onesButtonPressed(_ sender: Any) {
        onOnceAction?()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func monthlyButtonPressed(_ sender: Any) {
        onMonthlyAction?()
        dismiss(animated: true, completion: nil)
    }
}
