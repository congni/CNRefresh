//
//  UIImage+Extension.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/3/15.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     根据颜色、大小创建UIImage
     - parameter color: 颜色值
     - parameter size:  大小
     - returns: UIImage
     */
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), true, UIScreen.mainScreen().scale)
        color.set()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
