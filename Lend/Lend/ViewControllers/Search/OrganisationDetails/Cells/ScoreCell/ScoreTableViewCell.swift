//
//  ScoreTableViewCell.swift
//  Lend
//
//  Created by ОК on 29.04.2021.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(data: OrganisationItem.Score) {
        nameLabel.text = data.name
        valueLabel.text = "\(data.value)"
    }
}
