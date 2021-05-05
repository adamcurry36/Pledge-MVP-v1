//
//  OnboardingCell.swift
//  Lend
//
//  Created by ОК on 06.01.2021.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstSubtitle: UILabel!
    @IBOutlet weak var secondSubtitle: UILabel!
    
    @IBOutlet weak var imageTop: NSLayoutConstraint!
    @IBOutlet weak var imageLeading: NSLayoutConstraint!
    @IBOutlet weak var imageTrailing: NSLayoutConstraint!
    @IBOutlet weak var imageBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureWith(data: OnboardingModel) {
        imageView.image = UIImage(named: data.image)
        titleLabel.text = data.title
        firstSubtitle.text = data.firstSubtitle
        if let boldText = data.secondSubtitleInBold {
            let normalString = (data.secondSubtitle ?? "").replacingOccurrences(of: boldText, with: "")
            let attributedString = NSMutableAttributedString(string: normalString)
            
            let boldFont = UIFont(name: "HelveticaNeue-Bold", size: 13)!
            attributedString.append(NSMutableAttributedString(string:boldText, attributes: [NSAttributedString.Key.font : boldFont]))
            secondSubtitle.attributedText = attributedString
        } else {
            secondSubtitle.text = data.secondSubtitle ?? ""
        }
        
        imageTop.constant = data.imageInsets.top
        imageBottom.constant = data.imageInsets.bottom
        imageLeading.constant = data.imageInsets.left
        imageTrailing.constant = data.imageInsets.right
    }
}
