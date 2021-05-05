//
//  PaymentManager.swift
//  Lend
//
//  Created by ОК on 09.03.2021.
//

import Foundation
import Stripe
import PassKit


class PaymentManager: NSObject {
    typealias PaymentCallback = (PaymentManager.Result)->Void
    enum Result {
        case success(token: String)
        case failure
    }
    
    let merchandId = "merchant.com.alex.developer.mgsales"
    var paymentCallback: PaymentCallback?
    var amount: Float = 0.0
    var isOneTimeMode: Bool = false
    var title: String = ""
    
    private weak var presenter: UIViewController?
    private var stripeTokenId: String?
    
    init(with presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func pay(to title: String, amount: Float, isOneTimeMode: Bool, completion: @escaping PaymentCallback) {
        paymentCallback = completion
        self.isOneTimeMode = isOneTimeMode
        self.amount = amount
        self.title = title
        let request = PKPaymentRequest()
        request.merchantIdentifier = merchandId
        request.supportedNetworks = [.amex, .masterCard, .visa]
        request.countryCode = Locale.current.regionCode ?? "US"
        request.currencyCode = "USD"
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: title, amount: NSDecimalNumber(value: amount))]
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController?.delegate = self

        presenter?.present(applePayController!, animated: true, completion: nil)
    }
}

extension PaymentManager: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        self.presenter?.dismiss(animated: true) {
            if let token = self.stripeTokenId {
                self.paymentCallback?(Result.success(token: token))
            } else {
                self.paymentCallback?(Result.failure)
            }
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        STPAPIClient.shared.createToken(with: payment) { token, error in
            guard let token = token else {
                let errors: [Error]? = (error == nil) ? nil : [error!]
                return completion(PKPaymentAuthorizationResult(status: .failure, errors: errors))
            }
            
            NetworkManager.shared.subscriptionPayment(amount: self.amount, token: token.tokenId, isOneTimeMode: self.isOneTimeMode) { result in
                switch result {
                case .success:
                    self.stripeTokenId = token.tokenId
                    return completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                case .failure:
                    return completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                }
            }
        }
    }
}


