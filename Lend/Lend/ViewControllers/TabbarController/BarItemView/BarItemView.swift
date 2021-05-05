//
//  BarItemView.swift
//  Lend
//
//  Created by ОК on 16.01.2021.
//

import UIKit

class BarItemView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var activeIcon: UIImage? {
        didSet {
            iconImageView.image = activeIcon?.withRenderingMode(.alwaysTemplate)
        }
    }
    var inactiveIcon: UIImage?
    
    var onSelectedAction: ((Int)->Void)?
    var index: Int = 0
    
    var isSelected: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    private let connectXibName = "BarItemView"
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
        
    func setupView() {
        Bundle.main.loadNibNamed(connectXibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.fixToView(self)
    }
    
    func updateUI() {
        if isSelected {
            titleLabel.textColor = .black
            iconImageView.tintColor = .black
        } else {
            titleLabel.textColor = AppColor.grayBlueText.value
            iconImageView.tintColor = AppColor.grayBlueText.value
        }
    }
    
    @IBAction func selectedAction(_ sender: Any) {
        onSelectedAction?(index)
    }
    
}
