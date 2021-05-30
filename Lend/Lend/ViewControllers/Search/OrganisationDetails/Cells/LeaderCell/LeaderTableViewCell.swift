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
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoImageHeightConstraint: NSLayoutConstraint!
    
    static let infoImageViewLeading: CGFloat = 24.0 //from Storyboard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(data: OrganisationItem.Leader, infoImageHeight: CGFloat) {
        coverImageView.sd_setImage(with: data.avatarUrl)
        aboutLabel.text = data.about
        infoImageView.image = data.infoImage
        infoImageHeightConstraint.constant = infoImageHeight
        layoutIfNeeded()
    }
}
