//
//  HomeHeaderTableViewCell.swift
//  Lend
//
//  Created by ОК on 28.04.2021.
//

import UIKit

class HomeHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var roundWhiteBg: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    static let identifier = "HomeHeaderTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundWhiteBg.layer.cornerRadius = 0.5 * roundWhiteBg.bounds.height
        roundWhiteBg.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
