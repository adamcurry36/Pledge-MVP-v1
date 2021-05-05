//
//  MyBucketTableViewCell.swift
//  Lend
//
//  Created by ОК on 31.03.2021.
//

import UIKit
import SDWebImage

class MyBucketTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var slider: CustomSlider!
    
    var onSliderActionMoved: ((Int)->Void)?
    var onSliderActionEnded: ((Int)->Void)?
    
    private var roundedSliderValue: Int {
        return Int(round(slider.value))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        slider.setThumbImage(UIImage(named: "slider"), for: .normal)
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        slider.minimumValue = 0
    }

    func configureWith(data: OrganisationWithAmount, maxSliderValue: Int, isLastRow: Bool) {
        slider.maximumValue = Float(maxSliderValue)
        if maxSliderValue == 0 {
            slider.isUserInteractionEnabled = false
        } else {
            slider.isUserInteractionEnabled = true
        }
        slider.value = Float(data.amount)
        iconImageView.sd_setImage(with: data.organisation.imageUrl)
        nameLabel.text = data.organisation.name
        separatorView.isHidden = isLastRow
        updateAmountLabel(amount: data.amount)
    }
    
    func updateAmountLabel(amount: Int) {
        amountLabel.text = "$\(amount)"
        if amount == 0 {
            nameLabel.textColor = UIColor(named: "grayText3")
            amountLabel.textColor = UIColor(named: "grayText3")
        } else {
            nameLabel.textColor = .black
            amountLabel.textColor = .black
        }
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .moved:
                updateAmountLabel(amount: roundedSliderValue)
                onSliderActionMoved?(roundedSliderValue)
            case .ended:
                slider.value = Float(roundedSliderValue)
                onSliderActionEnded?(roundedSliderValue)
            default:
                break
            }
        }
    }
}
