//
//  DonateItemRef.swift
//  Lend
//
//  Created by ОК on 26.01.2021.
//

import Foundation
import FirebaseFirestore

struct DonateItemKey {
    static let amount = "amount"
    static let organisation = "organisation"
}

struct DonateItemRef {
    let id: String
    let amount: Int
    let organisationId: String
    
    init?(_ document: DocumentSnapshot) {
        guard
            let data = document.data(),
            let amount = data[DonateItemKey.amount] as? Int,
            let organisationId = data[DonateItemKey.organisation] as? String
        else { return nil }
        
        self.id = document.documentID
        self.amount = amount
        self.organisationId = organisationId
    }
}
