//
//  OrgProgramTableViewCell.swift
//  Lend
//
//  Created by ОК on 27.04.2021.
//

import UIKit

class OrgProgramTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(data: OrganisationItem.Program) {
        nameLabel.text = data.name
        aboutLabel.text = data.about
    }
}
