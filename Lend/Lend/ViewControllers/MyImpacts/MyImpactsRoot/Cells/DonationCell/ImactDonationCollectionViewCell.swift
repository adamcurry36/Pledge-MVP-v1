//
//  ImactDonationCollectionViewCell.swift
//  Lend
//
//  Created by ОК on 08.06.2021.
//

import UIKit

class ImactDonationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "grayBg")!.cgColor
        layer.cornerRadius = 18
    }
    
    func configureWith(data: DonateItem) {
        imageView.sd_setImage(with: data.organisation.imageUrl)
        amountLabel.text = "$\(data.amount)"
        periodLabel.text = "/Monthly"
        titleLabel.text = data.organisation.name
    }
}
