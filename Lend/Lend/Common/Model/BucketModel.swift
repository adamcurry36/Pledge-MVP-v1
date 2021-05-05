//
//  DonateCauseModel.swift
//  Lend
//
//  Created by ОК on 10.04.2021.
//

import Foundation

struct OrganisationWithAmount {
    var amount: Int
    let organisation: OrganisationItem
    var donateId: String?
}

struct BucketModel {
    let donatedOrganisations: [OrganisationWithAmount]
    let isOneTimePaymentMode: Bool
}
