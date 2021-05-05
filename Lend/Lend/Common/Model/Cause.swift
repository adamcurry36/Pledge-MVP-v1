//
//  Cause.swift
//  Lend
//
//  Created by ОК on 30.03.2021.
//

import Foundation
import FirebaseFirestore

struct CauseKey {
    static let imageUrl = "imageUrl"
    static let name = "name"
    static let regulary = "regulary"
    static let state = "state"
    static let description = "description"
}

struct Cause {
    enum State {
        case notStarted, now, finished
        
        var title: String {
            switch self {
            case .notStarted: return "Not started"
            case .now:       return "Happening now"
            case .finished:  return "Finished"
            }
        }
        
        init(intValue: Int) {
            if intValue == 0 {
                self = .notStarted
            } else if intValue == 1 {
                self = .now
            } else {
                self = .finished
            }
        }
    }
    
    let id: String
    let imageUrl: URL?
    let name: String
    let regulary: Bool
    let state: State
    let description: String
    
    init?(_ document: DocumentSnapshot) {
        guard
            let data = document.data(),
            let regulary = data[CauseKey.regulary] as? Bool,
            let intState = data[CauseKey.state] as? Int
        else { return nil }
        
        self.id = document.documentID
        self.imageUrl = URL(string: data[CauseKey.imageUrl] as? String ?? "")
        self.name = data[CauseKey.name] as? String ?? ""
        self.regulary = regulary
        self.state = State(intValue: intState)
        self.description = data[CauseKey.description] as? String ?? ""
    }
}
