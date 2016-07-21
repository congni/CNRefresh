//
//  UIFont+Extension.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/3/15.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

extension UIFont {
    /**
     字体
     - parameter size: 大小
     - returns: UIFont
     */
    class func fontWithSize(size: CGFloat) -> UIFont {
        if let font = UIFont.init(name: "BigYoungMediumGB2.0", size: size) {
            return font
        }
        
        return UIFont.systemFontOfSize(size)
    }
}
