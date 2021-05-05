//
//  RoundedViewWithShadow.swift
//  Lend
//
//  Created by ОК on 09.01.2021.
//

import UIKit

class RoundedViewWithShadow: UIView, ShadowableRoundableView {

    var cornerRadius: CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var shadowColor: UIColor = UIColor.darkGray {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var shadowOffsetWidth: CGFloat = 3 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var shadowOffsetHeight: CGFloat = 3 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var shadowOpacity: Float = 0.4 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var shadowRadius: CGFloat = 4 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    private(set) lazy var shadowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        self.setNeedsLayout()
        return layer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setCornerRadiusAndShadow()
    }

}
