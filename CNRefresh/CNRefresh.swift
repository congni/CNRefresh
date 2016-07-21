//
//  CNRefresh.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/3/29.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

let contentOffsetKeyPath = "contentOffset"
let contentSizeKeyPath = "contentSize"

private var kRefreshStatue: RefreshStatue = .Normal
private var kHeadRefreshStyle: HeadRefreshStyle = HeadRefreshStyle.Image
private var kHeadRefreshTipLabelStyle: RefreshTipsLabelStyle = .Dynamic
private var kFootRefreshStyle: FootRefreshStyle = FootRefreshStyle.Activity
private var kFootRefreshTipLabelStyle: RefreshTipsLabelStyle = .Dynamic
private var kRefreshInteractStatue: RefreshInteractStatue = .Draging


// MARK: - 刷新
extension UIScrollView {
    /// 刷新状态
    var refreshStatue: RefreshStatue {
        get {
            return kRefreshStatue
        }
        
        set {
            kRefreshStatue = newValue
        }
    }
    /// 头部刷新类型
    var headRefreshStyle: HeadRefreshStyle {
        get {
            return kHeadRefreshStyle
        }
        
        set {
            kHeadRefreshStyle = newValue
        }
    }
    /// 顶部提示文本类型
    var headRefreshTipLabelStyle: RefreshTipsLabelStyle {
        get {
            return kHeadRefreshTipLabelStyle
        }
        
        set {
            kHeadRefreshTipLabelStyle = newValue
        }
    }
    /// 头部刷新类型
    var footRefreshStyle: FootRefreshStyle {
        get {
            return kFootRefreshStyle
        }
        
        set {
            kFootRefreshStyle = newValue
        }
    }
    /// 底部提示文本类型
    var footRefreshTipLabelStyle: RefreshTipsLabelStyle {
        get {
            return kFootRefreshTipLabelStyle
        }
        
        set {
            kFootRefreshTipLabelStyle = newValue
        }
    }
    /// 刷新交互状态
    var refreshInteractStatue: RefreshInteractStatue {
        get {
            return kRefreshInteractStatue
        }
        
        set {
            kRefreshInteractStatue = newValue
        }
    }
    
    private struct CNRefreshViewKey {
        static var headerViewKey: CNRefreshHeadView?
        static var footerViewKey: CNRefreshFootView?
    }
    
    var headView: CNRefreshHeadView? {
        get {
            return objc_getAssociatedObject(self, &CNRefreshViewKey.headerViewKey) as? CNRefreshHeadView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &CNRefreshViewKey.headerViewKey, newValue as CNRefreshHeadView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var footView: CNRefreshFootView? {
        get {
            return objc_getAssociatedObject(self, &CNRefreshViewKey.footerViewKey) as? CNRefreshFootView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &CNRefreshViewKey.footerViewKey, newValue as CNRefreshFootView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

// MARK: - 开启刷新模式
extension UIScrollView {
    /**
     开启顶部刷新模式
     - parameter action: 结果回调
     */
    public func headRefresh(action: (() -> Void)) {
        self.backgroundColor = CNRefreshProfile.headViewBackgroundColor
        if headView == nil {
            headView = CNRefreshHeadView(frame: CGRectMake(0, -CNRefreshProfile.kCNRefreshHeadViewHeight, self.frame.size.width, CNRefreshProfile.kCNRefreshHeadViewHeight), style: headRefreshStyle, tipLabelStyle: headRefreshTipLabelStyle)
            self.addSubview(headView!)
        }
        
        headView?.scrollView = self
        headView?.action = action
    }
    
    /**
     开启底部刷新模式
     - parameter action: 结果回调
     */
    public func footRefresh(action: (() -> Void)) {
        self.backgroundColor = CNRefreshProfile.footViewBackgroundColor
        if footView == nil {
            footView = CNRefreshFootView(frame: CGRectMake(0, self.frame.size.height, self.frame.size.width, CNRefreshProfile.kCNRefreshFootViewHeight), style: footRefreshStyle, tipLabelStyle: kFootRefreshTipLabelStyle)
            self.addSubview(footView!)
        }
        
        footView?.scrollView = self
        footView?.action = action
    }
    
    /**
     停止刷新
     */
    public func endRefresh() {
        headView?.endRefresh()
        footView?.endRefresh()
    }
    
    /**
     底部刷新删除
     */
    public func removeFootRefresh() {
        self.contentInset = UIEdgeInsetsMake(self.contentInset.top, 0, 0, 0)
        footView?.removeReFresh()
        footView = nil
    }
    
    /**
     顶部刷新删除
     */
    public func removeHeaderRefresh() {
        self.contentInset = UIEdgeInsetsMake(self.contentInset.top, 0, 0, 0)
        headView?.removeReFresh()
        headView = nil
    }
}

