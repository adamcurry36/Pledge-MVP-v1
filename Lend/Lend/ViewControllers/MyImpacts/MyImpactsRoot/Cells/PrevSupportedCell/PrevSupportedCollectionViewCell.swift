//
//  PrevSupportedCollectionViewCell.swift
//  Lend
//
//  Created by ОК on 08.06.2021.
//

import UIKit

class PrevSupportedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "grayBg")!.cgColor
        layer.cornerRadius = 18
    }

    func configureWith(data: OrganisationItem) {
        imageView.sd_setImage(with: data.imageUrl)
        titleLabel.text = data.name
        typeLabel.text = data.filterName ?? ""
    }

}
