//
//  NSTimer+Extension.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/4/5.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

public typealias TimerExcuteClosure = @convention(block)()->()

extension NSTimer {
    /**
     定时器
     - parameter ti:      时间
     - parameter closure: 回调
     - parameter yesOrNo: 是否重复
     - returns: NSTimer
     */
//    public class func YQ_scheduledTimerWithTimeInterval(ti:NSTimeInterval, closure:TimerExcuteClosure, repeats yesOrNo: Bool) -> NSTimer {
//        return self.scheduledTimerWithTimeInterval(ti, target: self, selector: #selector(NSTimer.excuteTimerClosure(_:)), userInfo: unsafeBitCast(closure, AnyObject.self), repeats: yesOrNo)
//    }
//        
//    class func excuteTimerClosure(timer: NSTimer) {
//        let closure = unsafeBitCast(timer.userInfo, TimerExcuteClosure.self)
//        closure()
//    }
}
