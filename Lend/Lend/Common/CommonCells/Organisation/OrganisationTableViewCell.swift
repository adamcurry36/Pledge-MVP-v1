//
//  OrganisationTableViewCell.swift
//  Lend
//
//  Created by ОК on 20.01.2021.
//

import UIKit
import SDWebImage

class OrganisationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var chevronIconImageView: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    
    var onMenuAction: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(data: OrganisationItem, showMenu: Bool) {
        if showMenu {
            chevronIconImageView.isHidden = true
            menuButton.isHidden = false
        } else {
            chevronIconImageView.isHidden = false
            menuButton.isHidden = true
        }
        
        imgView.sd_setImage(with: data.imageUrl)
        nameLabel.text = data.name
        filterTitleLabel.text = data.filterName ?? ""
        aboutLabel.text = data.about
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        onMenuAction?()
    }
}
