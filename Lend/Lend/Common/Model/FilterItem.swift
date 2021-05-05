//
//  FilterItem.swift
//  Lend
//
//  Created by ОК on 20.01.2021.
//

import Foundation
import FirebaseFirestore

struct FilterItem: Equatable {
    let id: String
    let name: String
    let imageUrl: URL
    let color: UIColor
    
    init?(_ document: DocumentSnapshot) {
        guard let data = document.data(),
              let imageUrlStr = data["imageUrl"] as? String,
              let imageUrl = URL(string: imageUrlStr)
        else { return nil }
        
        self.id = document.documentID
        self.name = data["name"] as? String ?? ""
        self.imageUrl = imageUrl
        
        let colorString = data["color"] as? String ?? ""
        self.color = UIColor(hexString: colorString) ?? UIColor(named: "pinkBg2")!
    }
    
    static func == (lhs: FilterItem, rhs: FilterItem) -> Bool {
        return lhs.id == rhs.id
    }
}

