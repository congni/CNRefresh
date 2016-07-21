//
//  CNRefreshProfile.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/3/30.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

/**
 刷新状态
 - Normal:     正常状态
 - Refreshing: 正在刷新
 */
public enum RefreshStatue {
    case Normal
    case Refreshing
}

/**
 刷新交互状态
 - Draging:    拖拽中
 - Release:    释放
 - Refreshing: 刷新中
 - EndRefresh: 刷新完成
 */
public enum RefreshInteractStatue {
    case Draging
    case Release
    case Refreshing
    case EndRefresh
}

/**
 头部刷新模式
 - Activity:       加载组件
 - Image:          图片
 - ImageAnimation: 序列动画
 - CircleLoading:  转圈动画
 */
public enum HeadRefreshStyle {
    case Activity
    case Image
    case ImageAnimation
    case CircleLoading
}

/**
 底部刷新模式
 - Activity:       加载组件
 - Image:          图片
 - ImageAnimation: 序列动画
 - Button:         按钮模式
 */
public enum FootRefreshStyle {
    case Activity
    case Image
    case ImageAnimation
    case Button
}

/**
 刷新的文本类型
 - None:    没有文本，即没有文字提示
 - Dynamic: 动态文本提示，即文字会随着拖拽来动态变化，如下拉刷新、松开立即刷新、正在加载数据、数据加载完成
 - Static:  静态文本提示，即文字一直都是一个状态，不会变化，如正在加载中
 */
public enum RefreshTipsLabelStyle {
    case None
    case Dynamic
    case Static
}

/// CNRefresh配置文件
class CNRefreshProfile {
    /// 顶部背景色
    static var headViewBackgroundColor: UIColor = UIColor.colorWithHexString("555555")
    /// 底部背景色
    static var footViewBackgroundColor: UIColor = UIColor.colorWithHexString("555555")
    /// 顶部高度
    static var kCNRefreshHeadViewHeight: CGFloat = 60.0
    /// 底部高度
    static var kCNRefreshFootViewHeight: CGFloat = 60.0

    /// 顶部文字组件间距
    static var headTipsLabelOffset: UIOffset = UIOffset(horizontal: 0.0, vertical: 5.0)
    /// 顶部文字组件颜色值
    static var headTipsLabelTextColor: UIColor = UIColor.colorWithHexString("ffffff")
    /// 顶部文字组件字体大小
    static var headTipsLabelTextFontSize: CGFloat = 12.0
    
    /// 底部文字组件间距
    static var footTipsLabelOffset: UIOffset = UIOffset(horizontal: 0.0, vertical: 5.0)
    /// 底部文字组件颜色值
    static var footTipsLabelTextColor: UIColor = UIColor.colorWithHexString("ffffff")
    /// 底部文字组件字体大小
    static var footTipsLabelTextFontSize: CGFloat = 12.0
    
    /// 顶部退拽状态的文案
    static var dragingStatueHeadLabelText: String = "下拉刷新"
    /// 底部拖拽状态的文案
    static var dragingStatueFootLabelText: String = "上拉刷新"
    /// 释放状态的文案
    static var releaseStatueText: String = "松开立即刷新"
    /// 刷新中的文案
    static var refreshingStaueText: String = "正在加载数据"
    /// 停止刷新的文案
    static var endRefreshStaueText: String = "数据加载完成"
    
    /// 底部刷新按钮模式下的文案
    static var footButtonStyleTitle = "点击加载更多"
    /// 底部刷新按钮模式下的颜色值
    static var footButtonStyleTitleColor = UIColor.whiteColor()
    /// 底部刷新按钮模式下的字体大小
    static var footButtonStyleTitleFontSize = 13.0
    
    /// 提示文本静态文案
    static var tipLabelStaticText: String = "努力加载中..."
    /// 加载的图片
    static var loadingImage = UIImage(named: "CNRefresh.bundle/arrow")!
    /// 图片序列动画
    static var loadingAnimationImages = (preName: "CNRefresh.bundle/dropdown_loading_0", startIndex: 1, endIndex: 2)
    /// 转圈动画的颜色值
    static var circleLoadingStrokeColor = UIColor.colorWithHexString("E1DEDE").CGColor
}