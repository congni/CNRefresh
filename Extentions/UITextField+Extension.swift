//
//  UITextField+Extension.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/4/12.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

extension UITextField {
    /**
     placeholder颜色值设定
     - parameter color: 颜色
     */
    func placeholderColor(color: UIColor) {
        if self.placeholder != nil {
            let attribute = [NSForegroundColorAttributeName: color]
            let attributeString = NSAttributedString(string: self.placeholder!, attributes: attribute)
            
            self.attributedPlaceholder = attributeString
        }
    }
}
