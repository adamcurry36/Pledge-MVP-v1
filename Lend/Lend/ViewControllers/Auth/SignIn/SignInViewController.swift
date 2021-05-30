//
//  SignInViewController.swift
//  Lend
//
//  Created by ОК on 09.01.2021.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emailInputView: InputView!
    @IBOutlet weak var passwordInputView: InputView!
    
    @IBOutlet weak var signInButton: RoundedButtonWithShadow!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    
    var email: String {
        return emailInputView.textField.text ?? ""
    }
    
    var password: String {
        return passwordInputView.textField.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInputViews()
        signInButton.cornerRadius = signInButton.bounds.height
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapRecognizer(recognizer:))))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupInputViews() {
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
            passwordInputView.error = "Please enter your password"
        }
    }
    
    func manageAuthError(_ error: Error) {
        emailInputView.error = nil
        passwordInputView.error = nil
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch errorCode {
            case .userNotFound:
                emailInputView.error = "User not found"
            case .wrongPassword:
                passwordInputView.error = "Wrong Password"
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
        view.endEditing(true)
        guard Validator.isEmailValid(email) else {
            emailInputView.error = Constants.Error.emailInputError
            return
        }
        
        emailInputView.error = nil
        
        guard Validator.isPasswordValid(password) else {
            passwordInputView.error = "Please enter your password"
            return
        }
        
        passwordInputView.error = nil
        
        view.startActivityAnimating()
        FirestoreManager.shared.signIn(email: email, password: password) { [weak self] error in
            guard let self = self else { return }
            
            self.view.stopActivityAnimating()
            guard error == nil else {
                self.manageAuthError(error!)
                return
            }
            
            Coordinator.redirectToWelcome()
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        view.endEditing(true)
        guard Validator.isEmailValid(email) else {
            emailInputView.error = Constants.Error.emailInputError
            return
        }
        
        emailInputView.error = nil
        
        view.startActivityAnimating()
        FirestoreManager.shared.resetPassword(email: email) { [weak self]  error in
            guard let strongSelf = self else { return }
            
            strongSelf.view.stopActivityAnimating()
            if let error = error {
                strongSelf.showToastAlert(message: error, type: .error)
            } else {
                strongSelf.showToastAlert(message: "Check the email to reset password", type: .success)//todo:  //check text
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if navigationController?.viewControllers.count ?? 0 > 2 {
            navigationController?.popViewController(animated: true)
        } else {
            Coordinator.presentSignUp(from: self)
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
