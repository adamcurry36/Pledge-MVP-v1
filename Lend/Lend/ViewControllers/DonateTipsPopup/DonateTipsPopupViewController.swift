//
//  DonateTipsPopupViewController.swift
//  Lend
//
//  Created by ОК on 21.01.2021.
//

import UIKit

class DonateTipsPopupViewController: UIViewController {
    
    @IBOutlet weak var redBgView: UIView!
    @IBOutlet weak var dollarSignLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var peopleCountLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var donateButton: RoundedButtonWithShadow!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var redBgViewBottom: NSLayoutConstraint!
    
    var onDonateAction: ((Int)->Void)?
    let lendOrganisation = "Pledge"
    
    var tipsAmount: Int = 3
    private var paymentManager: PaymentManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        redBgView.layer.cornerRadius = 40
        redBgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        dollarSignLabel.layer.cornerRadius = 0.5 * dollarSignLabel.bounds.height
        contentView.layer.cornerRadius = 40
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        donateButton.cornerRadius = 0.5 * donateButton.bounds.height
        textField.isUserInteractionEnabled = false
        addToolbarOnKeyboard(textField: textField)
        if let tips = UserManager.shared.user?.tips {
            tipsAmount = tips
        }
        updateUI()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func updateUI() {
        textField.text = "\(tipsAmount)"
        imageViewHeight.constant = 75
        imageViewLeading.constant = 0
        imageViewTrailing.constant = 0
        if tipsAmount == 0 {
            imageView.image = UIImage(named: "feeling_blue")
            self.peopleCountLabel.text = "Nobody's Donation"
        } else if tipsAmount == 1 {
            imageView.image = UIImage(named: "1")
            self.peopleCountLabel.text = "1 Person’s donation"
        } else if tipsAmount == 2 {
            imageView.image = UIImage(named: "2")
            self.peopleCountLabel.text = "2 People’s Donations"
        } else if tipsAmount == 3 {
            imageView.image = UIImage(named: "3")
            self.peopleCountLabel.text = "3 People’s Donations"
        } else {
            imageView.image = UIImage(named: "4")
            imageViewHeight.constant = 124
            imageViewLeading.constant = 20
            imageViewTrailing.constant = -20
            self.peopleCountLabel.text = "\(tipsAmount) People’s Donations"
        }
    }
    
    func loadData() {
        view.startActivityAnimating()
        FirestoreManager.shared.fetchUpdateUser() { [weak self] success in
            self?.view.stopActivityAnimating()
            if success {
                if let tips = UserManager.shared.user?.tips {
                    self?.tipsAmount = tips
                }
                self?.updateUI()
            }
        }
    }
    
    private func addToolbarOnKeyboard(textField: UITextField){
        let toolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default

        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelButtonAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [cancel, flexSpace, done]
        toolbar.items = items
        toolbar.sizeToFit()

        textField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        textField.isUserInteractionEnabled = false
        textField.resignFirstResponder()
        var value = Int(textField.text ?? "") ?? 0
        
        if value < 0 {
            value = 0
        } 
        
        tipsAmount = value
        updateUI()
    }
    
    @objc func cancelButtonAction() {
        textField.text = "\(tipsAmount)"
        textField.isUserInteractionEnabled = false
        textField.resignFirstResponder()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donateButtonPressed(_ sender: Any) {
        dismiss(animated: true) {
            self.onDonateAction?(self.tipsAmount)
        }
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        guard tipsAmount > 0 else { return }
        tipsAmount -= 1
        updateUI()
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        tipsAmount += 1
        updateUI()
    }
    
    @IBAction func customTipButtonPressed(_ sender: Any) {
        textField.isUserInteractionEnabled = true
        if !textField.isFirstResponder {
            textField.becomeFirstResponder()
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.5
        
        let bottomOffset = UIScreen.main.bounds.height - redBgView.bounds.height - safeAreaInsets.top
        contentViewBottom.constant = bottomOffset
        redBgViewBottom.constant = bottomOffset
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.5
        contentViewBottom.constant = 0
        redBgViewBottom.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
