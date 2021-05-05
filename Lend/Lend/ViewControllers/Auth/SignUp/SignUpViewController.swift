//
//  SignUpViewController.swift
//  Lend
//
//  Created by ОК on 09.01.2021.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameInputView: InputView!
    @IBOutlet weak var emailInputView: InputView!
    @IBOutlet weak var passwordInputView: InputView!
    
    @IBOutlet weak var signUpButton: RoundedButtonWithShadow!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    
    var username: String {
        return nameInputView.textField.text ?? ""
    }
    
    var email: String {
        return emailInputView.textField.text ?? ""
    }
    
    var password: String {
        return passwordInputView.textField.text ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInputViews()
        signUpButton.cornerRadius = signUpButton.bounds.height

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(recognizer:))))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setupInputViews() {
        nameInputView.titleLabel.text = "Name"
        emailInputView.titleLabel.text = "Email Address"
        emailInputView.textField.keyboardType = .emailAddress
        emailInputView.onDidEndEditing = {
            self.updateEmailInputView()
        }
        passwordInputView.titleLabel.text = "Password"
        passwordInputView.textField.isSecureTextEntry = true
        passwordInputView.onDidEndEditing = {
            self.updatePasswordInputView()
        }
    }
    
    func updateEmailInputView() {
        if Validator.isEmailValid(email) {
            emailInputView.error = nil
        } else {
            emailInputView.error = Constants.Error.emailInputError
        }
    }
    
    func updatePasswordInputView() {
        if Validator.isPasswordValid(password) {
            passwordInputView.error = nil
        } else {
            passwordInputView.error = Constants.Error.passwordInputError
        }
    }
    
    func manageAuthError(_ error: Error?) {
        emailInputView.error = nil
        passwordInputView.error = nil
        if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
            switch errorCode {
            case .emailAlreadyInUse:
                emailInputView.error = "The email is already in use"
            default:
                emailInputView.error = ""
                passwordInputView.error = Constants.Error.unexpectedError
            }
        } else {
            emailInputView.error = ""
            passwordInputView.error = Constants.Error.unexpectedError
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        if navigationController?.viewControllers.count ?? 0 > 2 {
            navigationController?.popViewController(animated: true)
        } else {
            Coordinator.presentSignIn(from: self)
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        view.endEditing(true)
        guard Validator.isEmailValid(email) else {
            emailInputView.error = Constants.Error.emailInputError
            return
        }
        
        emailInputView.error = nil
        
        guard Validator.isPasswordValid(password) else {
            passwordInputView.error = Constants.Error.passwordInputError
            return
        }
        
        passwordInputView.error = nil
        
        let validDisplayName = username.isEmpty ? nil : username
        
        view.startActivityAnimating()
        FirestoreManager.shared.signUp(email: email, password: password, displayName: validDisplayName) { [weak self] success, error in
            guard let self = self else { return }
            
            self.view.stopActivityAnimating()
            guard success else {
                self.manageAuthError(error)
                return
            }
            
            Coordinator.redirectToStartDonate()
        }
    }
    
    @objc func tapRecognizer(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.5
        scrollViewBottom.constant = keyboardSize.height
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.5
        scrollViewBottom.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
