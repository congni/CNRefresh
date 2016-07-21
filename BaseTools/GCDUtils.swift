//
//  GCDUtils.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/4/14.
//  Copyright © 2016年 好居. All rights reserved.
//


import UIKit
import Foundation

typealias Task = (cancel : Bool) -> Void

/// GCD工具库(其实还有一个比较牛逼的GCD第三方库(Async),但是貌似要iOS8以上)
class GCDUtils {
    static var GlobalMainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    
    /**
     延迟
     - parameter time: 延迟时间
     - parameter task: 回调
     - returns: Task
     */
    static func delay(time:NSTimeInterval, task:()->()) ->  Task? {
        
        func dispatch_later(block:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(time * Double(NSEC_PER_SEC))),
                dispatch_get_main_queue(),
                block)
        }
        
        var closure: dispatch_block_t? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    dispatch_async(dispatch_get_main_queue(), internalClosure);
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(cancel: false)
            }
        }
        
        return result;
    }
    
    /**
     取消延迟任务
     - parameter task: task
     */
    static func cancel(task:Task?) {
        task?(cancel: true)
    }
}
