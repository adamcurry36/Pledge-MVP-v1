//
//  FilterCollectionViewCell.swift
//  Lend
//
//  Created by ОК on 20.01.2021.
//

import UIKit
import SDWebImage

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectorBgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectorBgView.layer.cornerRadius = 0.5 * selectorBgView.bounds.height
    }

    func configureWith(data: FilterItem, isSelected: Bool) {
        titleLabel.text = data.name
        imageView.sd_setImage(with: data.imageUrl)
        
        if isSelected {
            selectorBgView.backgroundColor = data.color
        } else {
            selectorBgView.backgroundColor = .clear
        }
    }
}
