//
//  LendUser.swift
//  Lend
//
//  Created by ОК on 14.01.2021.
//

import Foundation
import FirebaseFirestore

struct LendUserKey {
    static let email = "email"
    static let displayName = "displayName"
    static let defaultDonateAmount = "defaultDonateAmount"
    static let tipsAmount = "tipsAmount"
}

struct LendUser {
    let email: String
    let displayName: String?
    var firstName: String? {
        return (displayName ?? "").components(separatedBy: " ").first //todo: check //???
    }
    var lastName: String? {
        return (displayName ?? "").components(separatedBy: " ").last //todo: check //???
    }
    
    var defaultDonateAmount: Int
    var tips: Int?
    
    init?(_ document: DocumentSnapshot?) {
        guard
            let data = document?.data(),
            let email = data[LendUserKey.email] as? String
        else { return nil }
        
        self.email = email
        self.displayName = data[LendUserKey.displayName] as? String
        self.defaultDonateAmount = data[LendUserKey.defaultDonateAmount] as? Int ?? 0
        self.tips = data[LendUserKey.tipsAmount] as? Int
    }
    
    init(email: String, displayName: String?) {
        self.email = email
        self.displayName = displayName
        self.defaultDonateAmount = 0
    }
}
