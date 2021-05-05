//
//  Utils.swift
//  Lend
//
//  Created by ОК on 21.01.2021.
//

import UIKit

var keyWindow: UIWindow? {
    return UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
}

var safeAreaInsets: UIEdgeInsets {
    return keyWindow?.safeAreaInsets ?? .zero
}
