//
//  UIViewController+DonateFlow.swift
//  Lend
//
//  Created by ОК on 08.05.2021.
//

import Foundation

import UIKit

extension UIViewController {
    
    //MARK: - Pablic
    
    func showDonateOrganisationFlow(_ organisation: OrganisationItem) {
        showChooseOnceOrMonthly(organisationOrCause: organisation)
    }
    
    func showDonateCauseFlow(_ cause: Cause) {
        showChooseOnceOrMonthly(organisationOrCause: cause)
    }
    
    //MARK: - Private
    
    private func showBacket(organisationOrCause: Any, donateType: DonateType) {
        let vc = Coordinator.instantiateMyBucketVC()
        if let cause = organisationOrCause as? Cause {
            vc.cause = cause
        }
        if let organisation = organisationOrCause as? OrganisationItem {
            vc.organizations = [organisation]
        }
        
        vc.isOneTimePaymentMode = donateType == .once
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showAdjustOneTimePaymentAmount(organisationOrCause: Any) {
        let vc = Coordinator.instantiateAdjustDonateAmountVC()
        vc.causeOrOrganisationToPayOneTime = organisationOrCause
        vc.isOneTimePaymentMode = true
        vc.donateAmount = UserManager.shared.oneTimeDonateAmout
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showChooseOnceOrMonthly(organisationOrCause: Any) {
        let vc = Coordinator.instantiateChooseDonateOnceOrMonthlyVC()
        vc.onDonateTypeSelected = { [weak self] donateType in
            self?.donateStepOne(organisationOrCause: organisationOrCause, donateType: donateType)
        }
        presentOverFullScreen(vc)
    }
    
    private func donateStepOne(organisationOrCause: Any, donateType: DonateType) {
        if let completeDonation = UserManager.shared.completeDonation, completeDonation.type == donateType {
            showBacket(organisationOrCause: organisationOrCause, donateType: donateType)
            return
        }
        
        if UserManager.shared.completeDonation == nil {
            donateStepTwo(organisationOrCause: organisationOrCause, donateType: donateType)
        } else {
            showAlert(message: "Reset previous bucket?", title: "", options: ["OK", "Cancel"], firstOptionStyle: nil) { title in
                if title == "OK" {
                    self.donateStepTwo(organisationOrCause: organisationOrCause, donateType: donateType)
                }
            }
        }
    }
    
    private func donateStepTwo(organisationOrCause: Any, donateType: DonateType) {
        if donateType == .once {
            showAdjustOneTimePaymentAmount(organisationOrCause: organisationOrCause)
        } else {
            if UserManager.shared.shouldSetAmount  {
                showDonationConfirmation(organisationOrCause: organisationOrCause)
            } else {
                showBacket(organisationOrCause: organisationOrCause, donateType: donateType)
            }
        }
    }
    
    func showDonationConfirmation(organisationOrCause: Any) {
        let vc = Coordinator.instantiateDonationConfirmationVC()
        vc.organisationOrCause = organisationOrCause
        Coordinator.rootTabbar?.setTabbarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}

