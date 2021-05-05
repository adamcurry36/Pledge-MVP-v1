//
//  ActionTableViewCell.swift
//  Lend
//
//  Created by ОК on 03.05.2021.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(title: String, hideSeparator: Bool) {
        separator.isHidden = hideSeparator
        titleLabel.text = title
    }
   
}
