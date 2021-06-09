//
//  AppColor.swift
//  Lend
//
//  Created by ОК on 25.01.2021.
//

import UIKit

enum AppColor: String {
    case blue               //#3C7EFD
    case midBlue               //#0BB4F3
    case borderGray         //#E4E4E4
    case brown              //#9F8064
    case darkBlue           //#13305C
    case darkGrayButtonBg   //#463C3C
    case darkGrayText       //#837F7F
    case darkRedText        //#A70505
    case gradientGreen      //#79B89D
    case grayBg             //#DFE0E2
    case grayBg2            //FDFAFA
    case grayBlueText       //#5B7083
    case grayButtonBg       //#EDEDED
    case graySeparator      //#C3CDD4
    case graySliderBg       //B4B4B4
    case grayTabbarBg       //#FEFFFE
    case grayText           //#9A9A9A
    case grayText2          //#F2F2F2
    case grayText3          //#6F7070
    case lightGray          //#F7F7F8
    case lightRed           //#D59A84
    case lightRed2          //#D48585
    case pinkBg             //#FCD0D0
    case pinkBg2            //#F7DEDE
    case redBg              //#CB1D1D
        
    var value: UIColor {
        return UIColor(named: self.rawValue)!
    }
}


