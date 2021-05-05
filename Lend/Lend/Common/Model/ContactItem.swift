//
//  ContactItem.swift
//  Lend
//
//  Created by ОК on 22.01.2021.
//

import Foundation


struct ContactItem {
    let name: String
    let webUrl: URL
    let icon: String
    
    static func fromData(_ data: Any?) -> [ContactItem] {
        guard let dataDict = data as? [String:Any] else { return [] }
        
        var result: [ContactItem] = []
        for item in dataDict {
            if let strUrl = item.value as? String, let url = URL(string: strUrl) {
                var iconName = "Icon feather-globe"
                if item.key.lowercased().contains("instagram") {
                    iconName = "Icon feather-instagram"
                } else if item.key.lowercased().contains("facebook") {
                    iconName = "Icon awesome-facebook"
                }
                
                result.append(ContactItem(name: item.key, webUrl: url, icon: iconName))
            }
        }
        return result
    }
}
