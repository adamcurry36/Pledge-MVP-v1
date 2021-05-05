//
//  Errors.swift
//  Lend
//
//  Created by Oleksiy Kryvtsov on 04.02.2021.
//

import Foundation


enum APIError: Error {
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "Unknown error"
        }
    }
}
