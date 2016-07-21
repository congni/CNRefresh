//
//  UILabel+Extension.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/3/16.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

// MARK: - 快速创建UILable
extension UILabel {
    convenience init(textColor: UIColor, textFontSize: CGFloat) {
        self.init()
        
        self.textColor = textColor
        self.font = UIFont.fontWithSize(textFontSize)
    }
}