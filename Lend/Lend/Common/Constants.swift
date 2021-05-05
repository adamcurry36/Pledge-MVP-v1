//
//  Constants.swift
//  Lend
//
//  Created by ОК on 25.01.2021.
//

import Foundation
import UIKit

struct Constants {
    
    static let minAmount = 1
    static let maxAmount = 42
    static let maxCauseAmount = 300
    static let maxTipsAmount = 5
    
    struct Error {
        static let emailInputError = "Email is not valid"
        static let passwordInputError = "Password is too short. 6 chars minimum"
        static let unexpectedError = "Unexpected error please try again"
    }
    
    struct Link {
        static let appstore = URL(string: "https://itunes.apple.com/app/id1480819828")!
    }
}


