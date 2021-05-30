//
//  UIViewController.swift
//  Lend
//
//  Created by ОК on 14.01.2021.
//

import UIKit

extension UIViewController {
    func showToastAlert(message: String, type: AlertType = .none, controllerToDismiss: UIViewController? = nil, onDismiss: (()->Void)? = nil) {
        let storyboard = UIStoryboard(name: "CustomAlert", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! CustomAlertViewController
        let dismissBlock = {
            if let controllerToDismis = controllerToDismiss {
                controllerToDismis.dismiss(animated: true) {
                    onDismiss?()
                }
            } else {
                vc.dismiss(animated: true) {
                    onDismiss?()
                }
            }
        }
        vc.message = message
        vc.type = type
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.onTouchButtonPressed = {
            dismissBlock()
        }
        
        present(vc, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                dismissBlock()
            }
        }
    }
    
    func showAlert(message: String, title: String = "", options: [String], firstOptionStyle: UIAlertAction.Style? = nil, completion: ((String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for option in options {
            let style:UIAlertAction.Style

            if let firstStyle = firstOptionStyle, option == options.first {
                style = firstStyle
            } else {
                style = .default
            }

            let action = UIAlertAction(title: option, style: style) { action in
                completion?(action.title)
            }

            alert.addAction(action)
        }

        present(alert, animated: true)
    }
    
    func showNetworkErrorAlert(onDismiss: (()->Void)? = nil) {
        showToastAlert(message: Constants.Error.unexpectedError, type: .error, onDismiss: onDismiss)
    }
    
    func presentOverFullScreen(_ vc: UIViewController) {
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func showActionSheet(items: [String], onDismissWithIndex: ((Int?)->Void)? = nil) {
        let storyboard = UIStoryboard(name: "CustomActionSheet", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! CustomActionSheetViewController
        vc.items = items
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.onIndexSelected = onDismissWithIndex
        present(vc, animated: true)
    }
}
