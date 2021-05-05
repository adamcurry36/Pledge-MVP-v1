//
//  UserManager.swift
//  Lend
//
//  Created by ОК on 14.01.2021.
//

import Foundation

fileprivate let key_oneTimeDonateAmout = "key_oneTimeDonateAmout"

class UserManager {
    static let shared: UserManager = UserManager()
    
    var user: LendUser?
    var completeDonation: BucketModel?
    var tmpDonateAmount: Int?
    private let defaultOneTimeDonateAmout: Int = 25
    
    var defaultDonateAmount: Int {
        return user?.defaultDonateAmount ?? 0
    }
    
    var oneTimeDonateAmout: Int {
        get {
            UserDefaults.standard.value(forKey: key_oneTimeDonateAmout) as? Int ?? Constants.minAmount
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key_oneTimeDonateAmout)
            UserDefaults.standard.synchronize()
        }
    }
    
    var shouldSetAmount: Bool {
        return tmpDonateAmount == nil && defaultDonateAmount == 0
    }
    
    func resetUserData() {
        user = nil
        completeDonation = nil
        tmpDonateAmount = nil
    }
}
