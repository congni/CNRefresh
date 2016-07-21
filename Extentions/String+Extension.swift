//
//  String+Extension.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/3/21.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

extension String {
    /// 转换UTF8 Data
    var nsdata: NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}
