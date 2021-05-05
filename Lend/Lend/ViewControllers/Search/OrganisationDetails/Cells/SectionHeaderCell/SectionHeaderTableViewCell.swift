//
//  SectionHeaderTableViewCell.swift
//  Lend
//
//  Created by ОК on 29.04.2021.
//

import UIKit

class SectionHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelTop: NSLayoutConstraint!
    @IBOutlet weak var separatorBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWithTitle(_ title: String, topOffset: CGFloat? = nil, bottomOffset: CGFloat? = nil) {
        titleLabel.text = title
        if let topOffset = topOffset {
            titleLabelTop.constant = topOffset
        }
        if let bottomOffset = bottomOffset {
            separatorBottom.constant = bottomOffset
        }
    }
    
}
