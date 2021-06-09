//
//  CauseCollectionViewCell.swift
//  Lend
//
//  Created by ОК on 08.06.2021.
//

import UIKit

class CauseCollectionViewCell: UICollectionViewCell {//todo: //delete class if not used
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bgConainer: UIView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bannerImageView.layer.cornerRadius = 20
        bgConainer.layer.cornerRadius = bannerImageView.layer.cornerRadius
    }

    func configureWith(data: Cause) {
        bannerImageView.sd_setImage(with: data.imageUrl)
        stateLabel.text = data.state.title.uppercased()
        titleLabel.text = data.name.uppercased()
    }
    
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        //todo:
    }

}
