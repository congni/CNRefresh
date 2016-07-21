//
//  NSArray+Extension.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/3/23.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

extension Array {
    /**
     删除指定obj
     - parameter object: obj对象
     - returns: Bool
     */
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerate() {
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
}
