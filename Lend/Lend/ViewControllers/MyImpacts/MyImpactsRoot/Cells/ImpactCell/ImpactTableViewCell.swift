//
//  ImpactTableViewCell.swift
//  Lend
//
//  Created by ОК on 26.01.2021.
//

import UIKit

class ImpactTableViewCell: UITableViewCell {//todo: //del
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var slider: CustomSlider!
    
    var onRemoveAction: (()->Void)?
    var onSliderAction: ((Float)->Void)?
    var isEditingMode: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        slider.minimumValue = 1
        slider.setThumbImage(UIImage(named: "slider"), for: .normal)
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    func configureWith(data: DonateItem, maxDonate: Int, isEditing: Bool) {
        self.isEditingMode = isEditing
        imgView.sd_setImage(with: data.organisation.imageUrl)
        nameLabel.text = data.organisation.name
        filterTitleLabel.text = data.organisation.filterName ?? ""
        amountLabel.text = "$\(data.amount)/month"
        
        if isEditing {
            actionButton.isUserInteractionEnabled = true
            actionButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
            actionButton.tintColor = UIColor(named: "redBg")
            slider.isHidden = false
            slider.maximumValue = Float(maxDonate)
            slider.value = Float(data.amount)
        } else {
            actionButton.isUserInteractionEnabled = false
            actionButton.setImage(UIImage(named: "f-arrow"), for: .normal)
            actionButton.tintColor = .black
            slider.isHidden = true
        }
    }
    
    func updateAmountLabel(amount: Int) {
        amountLabel.text = "$\(amount)/month"
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        onRemoveAction?()
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .moved:
                updateAmountLabel(amount: Int(slider.value))
            case .ended:
                onSliderAction?(slider.value)
            default:
                break
            }
        }
    }

}
