//
//  ContactCollectionViewCell.swift
//  Lend
//
//  Created by ОК on 22.01.2021.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWith(data: ContactItem) {
        titleLabel.text = data.name
        imageView.image = UIImage(named: data.icon)
    }

}
