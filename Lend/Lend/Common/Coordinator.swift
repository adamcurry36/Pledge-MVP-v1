//
//  Coordinator.swift
//  Lend
//
//  Created by ОК on 09.01.2021.
//

import UIKit

class Coordinator {
    
    private static let keyOnboardingFinished = "key_OnboardingFinished"
    
    static var onboardingFinished: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keyOnboardingFinished)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: keyOnboardingFinished)
            UserDefaults.standard.synchronize()
        }
    }
    
    private (set) static var appRootViewController: UIViewController? {
        get {
            return (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
        }
        
        set {
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = newValue
        }
    }
    
    static var rootTabbar: CustomTabbarViewController?
    
    static func redirectToAuth() {
        let storyboard = UIStoryboard(name: "AuthRoot", bundle: nil)
        appRootViewController = storyboard.instantiateInitialViewController()
    }
    
    static func presentAuth(from vc: UIViewController) {
        let storyboard = UIStoryboard(name: "AuthRoot", bundle: nil)
        let destinationVC = storyboard.instantiateInitialViewController()!
        destinationVC.modalTransitionStyle = .crossDissolve
        destinationVC.modalPresentationStyle = .overFullScreen
        vc.present(destinationVC, animated: true, completion: nil)
    }
    
    static func redirectToWelcome() {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        appRootViewController = storyboard.instantiateInitialViewController()!
    }
    
    static func redirectToStartDonate() {
        let storyboard = UIStoryboard(name: "StartDonate", bundle: nil)
        appRootViewController = storyboard.instantiateInitialViewController()!
    }
    
    static func redirectToRoot() {
        guard appRootViewController as? CustomTabbarViewController == nil else { return }
        
        let storyboard = UIStoryboard(name: "CustomTabbar", bundle: nil)
        let destinationVC = storyboard.instantiateInitialViewController() as! CustomTabbarViewController
        rootTabbar = destinationVC
        appRootViewController = destinationVC
    }
    
    static func presentRoot(from vc: UIViewController) {
        let storyboard = UIStoryboard(name: "CustomTabbar", bundle: nil)
        let destinationVC = storyboard.instantiateInitialViewController() as! CustomTabbarViewController
        rootTabbar = destinationVC
        
        destinationVC.modalTransitionStyle = .crossDissolve
        destinationVC.modalPresentationStyle = .overFullScreen
        vc.present(destinationVC, animated: true, completion: nil)
    }
    
    static func presentOnboarding(from vc: UIViewController) {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let destinationVC = storyboard.instantiateInitialViewController() as! OnboardingViewController
        destinationVC.modalTransitionStyle = .crossDissolve
        destinationVC.modalPresentationStyle = .overFullScreen
        vc.present(destinationVC, animated: true, completion: nil)
    }
    
    static func presentSignUp(from vc: UIViewController) {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let destinationVC = storyboard.instantiateInitialViewController() as! SignUpViewController
        if let nc = vc.navigationController {
            nc.pushViewController(destinationVC, animated: true)
        } else {
            destinationVC.modalTransitionStyle = .crossDissolve
            destinationVC.modalPresentationStyle = .overFullScreen
            vc.present(destinationVC, animated: true)
        }
    }
    
    static func presentSignIn(from vc: UIViewController) {
        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        let destinationVC = storyboard.instantiateInitialViewController() as! SignInViewController
        if let nc = vc.navigationController {
            nc.pushViewController(destinationVC, animated: true)
        } else {
            destinationVC.modalTransitionStyle = .crossDissolve
            destinationVC.modalPresentationStyle = .overFullScreen
            vc.present(destinationVC, animated: true)
        }
    }
    
    static func instantiateDonateTipsPopupVC() -> DonateTipsPopupViewController {
        let storyboard = UIStoryboard(name: "DonateTipsPopup", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! DonateTipsPopupViewController
        return vc
    }
    
    static func instantiateEarnedBadgeVC() -> EarnedBadgeViewController {
        let storyboard = UIStoryboard(name: "EarnedBadge", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! EarnedBadgeViewController
        return vc
    }
    
    static func instantiateDonateCauseVC() -> DonateCauseViewController {
        let storyboard = UIStoryboard(name: "DonateCause", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! DonateCauseViewController
        return vc
    }
    
    static func instantiateMyBucketVC() -> MyBucketViewController {
        let storyboard = UIStoryboard(name: "MyBucket", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! MyBucketViewController
        return vc
    }
    
    static func instantiateAdjustDonateAmountVC() -> AdjustDonateAmountViewController {
        let storyboard = UIStoryboard(name: "AdjustDonateAmount", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! AdjustDonateAmountViewController
        return vc
    }
    
    static func instantiateChooseDonateOnceOrMonthlyVC() -> ChooseDonateOnceOrMonthlyVC {
        let storyboard = UIStoryboard(name: "ChooseDonateOnceOrMonthly", bundle: nil)
        return storyboard.instantiateInitialViewController() as! ChooseDonateOnceOrMonthlyVC
    }
    
    static func instantiateDonationConfirmationVC() -> DonationConfirmationViewController {
        let storyboard = UIStoryboard(name: "DonationConfirmation", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DonationConfirmationViewController
    }
    
    static func instantiateHowMonthlyGivenWorksVC() -> HowMonthlyGivenWorksVC {
        let storyboard = UIStoryboard(name: "HowMonthlyGivenWorks", bundle: nil)
        return storyboard.instantiateInitialViewController() as! HowMonthlyGivenWorksVC
    }
    
    static func instantiateChooseAmountStepOneVC() -> ChooseAmountStepOneVC {
        let storyboard = UIStoryboard(name: "ChooseAmountStepOne", bundle: nil)
        return storyboard.instantiateInitialViewController() as! ChooseAmountStepOneVC
    }
    
    static func instantiateChooseRecipientsVC() -> ChooseRecipientsViewController {
        let storyboard = UIStoryboard(name: "ChooseRecipients", bundle: nil)
        return storyboard.instantiateInitialViewController() as! ChooseRecipientsViewController
    }
    
    static func instantiateDonateConfirmationVC() -> DonateConfirmationViewController {
        let storyboard = UIStoryboard(name: "DonateConfirmation", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DonateConfirmationViewController
    }
    
    static func instantiateDonateSuccessVC() -> DonateSuccessViewController {
        let storyboard = UIStoryboard(name: "DonateSuccess", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DonateSuccessViewController
    }
    
    static func instantiateDonateOrganizationVC() -> DonateOrganizationViewController {
        let storyboard = UIStoryboard(name: "DonateOrganization", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DonateOrganizationViewController
    }
    
    static func instantiateInfoVC() -> InfoViewController {
        let storyboard = UIStoryboard(name: "Info", bundle: nil)
        return storyboard.instantiateInitialViewController() as! InfoViewController
    }
    
}
