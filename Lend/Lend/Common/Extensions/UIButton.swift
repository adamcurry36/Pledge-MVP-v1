//
//  UIButton.swift
//  Lend
//
//  Created by ОК on 06.03.2021.
//

import UIKit

extension UIButton {
    func setUndlinedTitle(_ title: String? = nil) {
        let font = self.titleLabel?.font ?? UIFont.systemFont(ofSize: 16)
        let textColor = self.titleColor(for: .normal) ?? UIColor.black
        let attributes: [NSAttributedString.Key: Any] = [ .font: font, .foregroundColor: textColor, .underlineStyle: NSUnderlineStyle.single.rawValue]
            
        let title = title ?? (self.title(for: .normal) ?? "")
        let attributeString = NSMutableAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(attributeString, for: .normal)
    }
}
