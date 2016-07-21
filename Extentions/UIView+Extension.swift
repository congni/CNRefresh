//
//  UIView+Extension.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/3/28.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

extension UIView {
    /**
     UIView转换为UIImage
     - returns: UIImage
     */
    func getImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

// MARK: - 坐标
extension UIView {
    /// 左侧
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set {
            let frame = CGRectMake(newValue, self.top, self.width, self.height)
            self.frame = frame
        }
    }
    /// 右侧(self.left + self.width)
    var right: CGFloat {
        get {
            return self.left + self.width
        }
    }
    /// 顶部
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            let frame = CGRectMake(self.left, newValue, self.width, self.height)
            self.frame = frame
        }
    }
    /// 底部(self.top + self.height)
    var bottom: CGFloat {
        get {
            return self.top + self.height
        }
    }
    /// 高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            let frame = CGRectMake(self.left, self.top, self.width, newValue)
            self.frame = frame
        }
    }
    /// 宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            let frame = CGRectMake(self.left, self.top, newValue, self.height)
            self.frame = frame
        }
    }
}

