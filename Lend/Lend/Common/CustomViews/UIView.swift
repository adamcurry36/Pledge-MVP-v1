//
//  UIView.swift
//  Lend
//
//  Created by ОК on 09.01.2021.
//

import UIKit

let activityViewTag = 475647
extension UIView {
    
    func startActivityAnimating() {
        guard self.viewWithTag(activityViewTag) == nil else { return }
        
        let activityColor = UIColor.darkGray
        let bgColor: UIColor = .clear
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.backgroundColor = bgColor
        backgroundView.tag = activityViewTag
        backgroundView.isUserInteractionEnabled = true
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = backgroundView.center
        activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        
        backgroundView.addSubview(activityIndicator)
        
        self.addSubview(backgroundView)
    }
    
    func stopActivityAnimating() {
        if let background = viewWithTag(activityViewTag){
            background.removeFromSuperview()
        }
    }
    
    func fixToView(_ container: UIView!) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let attributes: [NSLayoutConstraint.Attribute] = [.leading, .trailing, .top, .bottom]
        for attribute in attributes {
            NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: container, attribute: attribute, multiplier: 1.0, constant: 0).isActive = true
        }
    }
    
    func addGradiant(colors: [CGColor]) {
        let gradientLayerName = "gradientLayer"

        if let oldlayer = self.layer.sublayers?.filter({$0.name == gradientLayerName}).first {
            oldlayer.removeFromSuperlayer()
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.25, y: 1 )
        gradientLayer.frame = self.bounds
        gradientLayer.name = gradientLayerName

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
