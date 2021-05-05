//
//  InputView.swift
//  Lend
//
//  Created by ОК on 09.01.2021.
//

import UIKit

class InputView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorIcon: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var roundedViewWithShadow: RoundedViewWithShadow!
    var onDidEndEditing: (()->Void)?
    
    var error: String? {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("InputView", owner: self, options: nil)
        insertSubview(contentView, at: 0)
        contentView.fixToView(self)
        
        roundedViewWithShadow.cornerRadius = 14
        roundedViewWithShadow.shadowRadius = 1
        roundedViewWithShadow.shadowOffsetHeight = 0
        roundedViewWithShadow.shadowOffsetWidth = 0
        roundedViewWithShadow.shadowOpacity = 0.2
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        roundedViewWithShadow.addGestureRecognizer(tap)
        textField.delegate = self
        updateUI()
    }

    func updateUI() {
        if let error = error {
            errorIcon.isHidden = false
            errorLabel.isHidden = false
            errorLabel.text = error
            roundedViewWithShadow.layer.borderWidth = 1
            roundedViewWithShadow.layer.borderColor = AppColor.redBg.value.cgColor
            roundedViewWithShadow.backgroundColor = AppColor.pinkBg2.value
        } else {
            errorIcon.isHidden = true
            errorLabel.isHidden = true
            roundedViewWithShadow.backgroundColor = AppColor.lightGray.value
            roundedViewWithShadow.layer.borderWidth = 0
            roundedViewWithShadow.layer.borderColor = nil
            roundedViewWithShadow.backgroundColor = AppColor.lightGray.value
        }
        
        roundedViewWithShadow.shadowLayer.fillColor = roundedViewWithShadow.backgroundColor?.cgColor
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if !textField.isFirstResponder {
            textField.becomeFirstResponder()
        }
    }
}

extension InputView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        onDidEndEditing?()
    }
}
