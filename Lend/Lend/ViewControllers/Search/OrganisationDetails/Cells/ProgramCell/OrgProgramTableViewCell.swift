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
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoImageHeightConstraint: NSLayoutConstraint!
    
    static let infoImageViewLeading: CGFloat = 22.0 //from Storyboard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(data: OrganisationItem.Program, infoImageHeight: CGFloat) {
        nameLabel.text = data.name
        aboutLabel.text = data.about
        infoImageView.image = data.infoImage
        infoImageHeightConstraint.constant = infoImageHeight
        layoutIfNeeded()
    }
}
