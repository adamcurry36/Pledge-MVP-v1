//
//  OrganisationWithAmountCell.swift
//  Lend
//
//  Created by ОК on 01.05.2021.
//

import UIKit

class OrganisationWithAmountCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(data: OrganisationWithAmount) {
        imgView.sd_setImage(with: data.organisation.imageUrl)
        nameLabel.text = data.organisation.name
        aboutLabel.text = data.organisation.about
        amountLabel.text = "$\(data.amount)"
    }
    
}
