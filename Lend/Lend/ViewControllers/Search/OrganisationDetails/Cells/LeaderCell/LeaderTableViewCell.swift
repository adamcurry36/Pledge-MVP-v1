//
//  LeaderTableViewCell.swift
//  Lend
//
//  Created by ОК on 26.04.2021.
//

import UIKit
import SDWebImage

class LeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(data: OrganisationItem.Leader) {
        coverImageView.sd_setImage(with: data.avatarUrl)
        aboutLabel.text = data.about
    }
}
