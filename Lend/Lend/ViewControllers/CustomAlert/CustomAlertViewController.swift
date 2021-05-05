//
//  CustomAlertViewController.swift
//  Lend
//
//  Created by ОК on 23.01.2021.
//

import UIKit

enum AlertType {
    case success, error, none
}

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var type: AlertType = .none
    var message: String = ""
    var isSecondModal: Bool = false
    var onTouchButtonPressed: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isSecondModal {
            view.backgroundColor = .clear
        } else {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
        
        switch type {
        case .success:
            iconImageView.image = UIImage(named: "ok toast")
        case .error:
            iconImageView.image = UIImage(named: "error toast")
        case .none:
            iconImageView.image = nil
        }
    
        messageLabel.text = message
    }
    
    @IBAction func touchButtonPressed(_ sender: Any) {
        onTouchButtonPressed?()
    }
    
}
