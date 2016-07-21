//
//  CNRefreshFootView.swift
//  PortalHaojuSwift
//
//  Created by haoju-congni on 16/3/29.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit



/// 底部刷新
class CNRefreshFootView: UIView {
    /// 组件容器
    private var contentView: UIView?
    /// 文字组件
    private var tipsLabel: UILabel?
    /// 加载组件
    private var activityView: UIActivityIndicatorView?
    /// 图片组件
    private var loadingImageView: UIImageView?
    /// 更多按钮组件
    private var moreButton: UIButton?
    /// observer context
    private var refreshFooterContext = 0
    
    /// 类型
    internal var style: FootRefreshStyle = FootRefreshStyle.Activity
    /// 提示文本类型
    internal var tipLabelStyle: RefreshTipsLabelStyle = .Dynamic
    /// 回调
    internal var action: (() -> ())? = {}
    /// UIScrollView设定
    internal weak var scrollView: UIScrollView? {
        didSet {
            if scrollView != nil {
                updateTipsLabelText()
                
                if style == FootRefreshStyle.Button {
                    scrollView?.contentInset = UIEdgeInsetsMake((scrollView?.contentInset.top)!, 0, height, 0)
                }
                
                scrollView?.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .New, context: &refreshFooterContext)
                scrollView?.addObserver(self, forKeyPath: contentSizeKeyPath, options: .New, context: &refreshFooterContext)
            }
        }
    }
    
    /**
     初始化
     - parameter frame: frame
     - parameter style: 类型
     - returns: self
     */
    init(frame: CGRect, style: FootRefreshStyle, tipLabelStyle: RefreshTipsLabelStyle) {
        self.style = style
        self.tipLabelStyle = tipLabelStyle
        super.init(frame: frame)
        
        self.backgroundColor = CNRefreshProfile.footViewBackgroundColor
        createUI()
    }
    
    /**
     根据类型，创建UI
     */
    private func createUI() {
        contentView = UIView()
        contentView?.height = self.height
        contentView?.width = self.width
        self.addSubview(contentView!)
        
        if style == .Activity {
            activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityView?.bounds = CGRectMake(0, 0, 50, 50)
            contentView?.addSubview(activityView!)
            activityView?.startAnimating()
            activityView?.left = contentView!.width / 2.0 - activityView!.width - CNRefreshProfile.headTipsLabelOffset.vertical / 2.0
            activityView?.top = (contentView!.height - activityView!.height) / 2.0
        } else if style == .Image {
            loadingImageView = UIImageView(image: CNRefreshProfile.loadingImage)
            loadingImageView?.frame.size = loadingImageView!.image!.size
            contentView!.addSubview(loadingImageView!)
            loadingImageView?.left = contentView!.width / 2.0 - loadingImageView!.width - CNRefreshProfile.headTipsLabelOffset.vertical / 2.0
            loadingImageView?.top = (contentView!.height - loadingImageView!.height) / 2.0
        } else if style == .ImageAnimation {
            let animationImageInfo = CNRefreshProfile.loadingAnimationImages
            var loadingAnimationImages = [UIImage]()
            var startIndex = animationImageInfo.startIndex
            let preName = animationImageInfo.preName
            let endIndex = animationImageInfo.endIndex
            
            while startIndex <= endIndex {
                let imageName = "\(preName)\(startIndex)"
                let animationImage = UIImage(named: imageName)
                
                if animationImage != nil {
                    loadingAnimationImages.append(animationImage!)
                }
                
                startIndex += 1
            }
            
            if loadingAnimationImages.count > 0 {
                loadingImageView = UIImageView()
                loadingImageView?.animationImages = loadingAnimationImages
                loadingImageView?.animationDuration = 0.5;
                loadingImageView?.animationRepeatCount = 0;
                contentView!.addSubview(loadingImageView!);
                loadingImageView?.frame.size = loadingAnimationImages[0].size
            } else {
                /// 如果发现序列图片数组是空的时候，则直接强转成图片类型
                loadingImageView = UIImageView(image: CNRefreshProfile.loadingImage)
                loadingImageView?.frame.size = loadingImageView!.image!.size
                contentView!.addSubview(loadingImageView!)
                
                style = .Image
            }
            
            loadingImageView?.left = contentView!.width / 2.0 - loadingImageView!.width - CNRefreshProfile.headTipsLabelOffset.vertical / 2.0
            loadingImageView?.top = (contentView!.height - loadingImageView!.height) / 2.0
        } else if style == .Button {
            /// 按钮模式下，tipLable的模式需为None
            tipLabelStyle = .None
            
            moreButton = UIButton(type: .Custom)
            moreButton?.setTitle(CNRefreshProfile.footButtonStyleTitle, forState: .Normal)
            moreButton?.setTitleColor(CNRefreshProfile.footButtonStyleTitleColor, forState: .Normal)
            moreButton?.titleLabel?.font = UIFont.fontWithSize(CGFloat(CNRefreshProfile.footButtonStyleTitleFontSize))
            moreButton?.sizeToFit()
            moreButton?.top = (contentView!.height - moreButton!.height) / 2.0
            moreButton?.left = (contentView!.width - moreButton!.width) / 2.0
            moreButton?.addTarget(self, action: #selector(CNRefreshFootView.loadingMoreInfo), forControlEvents: .TouchUpInside)
            contentView!.addSubview(moreButton!)
        }
        
        if tipLabelStyle != .None {
            tipsLabel = UILabel(textColor: CNRefreshProfile.headTipsLabelTextColor, textFontSize: CNRefreshProfile.headTipsLabelTextFontSize)
            contentView!.addSubview(tipsLabel!)
            tipsLabel?.left = contentView!.width / 2.0 + CNRefreshProfile.headTipsLabelOffset.vertical / 2.0
        }
    }
    
    /**
     监测，如果被调用到addSubView的时候，查找其父View
     - parameter newSuperview: newSuperview
     */
    override func willMoveToSuperview(newSuperview: UIView?) {
        if newSuperview != nil && ((newSuperview?.isKindOfClass(UIScrollView)) == true) {
            self.scrollView = newSuperview as? UIScrollView
            
            if style == FootRefreshStyle.Button {
                scrollView!.contentInset = UIEdgeInsetsMake(scrollView!.contentInset.top, 0, height, 0)
            }
        }
    }
    
    /**
     更新文字文案
     */
    private func updateTipsLabelText() {
        if tipLabelStyle != .None {
            switch self.scrollView!.refreshInteractStatue {
            case .Draging:
                tipsLabel?.text = CNRefreshProfile.dragingStatueHeadLabelText
            case .Release:
                tipsLabel?.text = CNRefreshProfile.releaseStatueText
            case .Refreshing:
                tipsLabel?.text = CNRefreshProfile.refreshingStaueText
            case .EndRefresh:
                tipsLabel?.text = CNRefreshProfile.endRefreshStaueText
            }
            
            tipsLabel?.sizeToFit()
            tipsLabel?.top = (contentView!.height - tipsLabel!.height) / 2.0
        }
    }
    
    /**
     按钮模式下的点击事件
     */
    func loadingMoreInfo() {
        moreButton?.removeFromSuperview()
        scrollView!.refreshInteractStatue = .Refreshing
        scrollView!.refreshStatue = .Refreshing
        action?()
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityView?.bounds = CGRectMake(0, 0, 50, 50)
        contentView!.addSubview(activityView!)
        activityView?.startAnimating()
        activityView?.left = (contentView!.width - activityView!.width) / 2.0
        activityView?.top = (contentView!.height - activityView!.height) / 2.0
    }
    
    /**
     按钮模式下的状态重置
     */
    func resetNormalStatue() {
        contentView!.addSubview(moreButton!)
        activityView?.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIScrollView 属性值监听回调
extension CNRefreshFootView {
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if self.superview == nil {
            scrollView!.removeObserver(self, forKeyPath: contentSizeKeyPath, context: &refreshFooterContext)
            scrollView!.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &refreshFooterContext)
        } else {
            refresh(keyPath!)
        }
    }
}

// MARK: - 外部调用
extension CNRefreshFootView {
    /**
     刷新(底部刷新，监听contentOffset和contentSize变化)
     - parameter key: 相关key值的变化
     */
    internal func refresh(key: String) {
        guard self.scrollView!.contentOffset.y >= 0 else {
            return
        }
        
        let contentOffsetY: CGFloat = self.scrollView!.contentOffset.y + self.scrollView!.frame.size.height
        let contentHeight = scrollView!.contentSize.height < self.scrollView!.frame.size.height ? self.scrollView!.frame.size.height : scrollView!.contentSize.height
        
        if key == contentSizeKeyPath {
            if scrollView!.height > contentHeight {
                self.top = self.scrollView!.frame.size.height
            } else {
                self.top = contentHeight
            }
        } else {
            guard self.scrollView!.refreshStatue != .Refreshing else {
                return
            }
            
            if self.scrollView!.contentOffset.y == 0.0 {
                if activityView?.isAnimating() == true {
                    activityView?.stopAnimating()
                }
                
                if loadingImageView?.isAnimating() == false {
                    loadingImageView?.stopAnimating()
                }
            }
            
            if self.scrollView!.contentSize.height < self.scrollView!.frame.size.height {
                if (self.scrollView!.contentOffset.y > 0) && (scrollView!.dragging == true) {
                    if self.scrollView!.refreshInteractStatue != .Draging {
                        self.scrollView!.refreshInteractStatue = .Draging
                        updateTipsLabelText()
                    }
                    
                    if activityView?.isAnimating() == false {
                        activityView?.startAnimating()
                    }
                    
                    if loadingImageView?.isAnimating() == false {
                        loadingImageView?.startAnimating()
                    }
                }
                
                if (self.scrollView!.contentOffset.y > CNRefreshProfile.kCNRefreshFootViewHeight)  && (scrollView!.dragging == true) {
                    if self.scrollView!.refreshInteractStatue != .Release {
                        self.scrollView?.refreshInteractStatue = .Release
                        updateTipsLabelText()
                    }
                }
                
                if (self.scrollView!.contentOffset.y > CNRefreshProfile.kCNRefreshFootViewHeight)  && (scrollView!.dragging == false) {
                    if self.scrollView!.refreshStatue != .Refreshing {
                        self.scrollView!.refreshStatue = .Refreshing
                    }
                    
                    if self.scrollView!.refreshInteractStatue != .Refreshing {
                        self.scrollView!.refreshInteractStatue = .Refreshing
                        updateTipsLabelText()
                        
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.scrollView!.contentInset = UIEdgeInsetsMake(-CNRefreshProfile.kCNRefreshFootViewHeight, 0, self.scrollView!.contentInset.bottom, 0)
                            }, completion: { (isComplete) -> Void in
                                if isComplete {
                                    self.action?()
                                }
                        })
                    }

                }
            } else {
                if ((contentOffsetY - contentHeight) >= 0) && (scrollView!.dragging == true) {
                    if self.scrollView!.refreshInteractStatue != .Draging {
                        self.scrollView!.refreshInteractStatue = .Draging
                        updateTipsLabelText()
                    }
                    
                    if activityView?.isAnimating() == false {
                        activityView?.startAnimating()
                    }
                    
                    if loadingImageView?.isAnimating() == false {
                        loadingImageView?.startAnimating()
                    }
                }
                
                if ((contentOffsetY - contentHeight) > CNRefreshProfile.kCNRefreshFootViewHeight)  && (scrollView!.dragging == true) {
                    if self.scrollView!.refreshInteractStatue != .Release {
                        self.scrollView!.refreshInteractStatue = .Release
                        updateTipsLabelText()
                    }
                }
                
                if ((contentOffsetY - contentHeight) > CNRefreshProfile.kCNRefreshFootViewHeight)  && (scrollView!.dragging == false) {
                    if self.scrollView!.refreshStatue != .Refreshing {
                        self.scrollView!.refreshStatue = .Refreshing
                    }
                    
                    if self.scrollView!.refreshInteractStatue != .Refreshing {
                        self.scrollView!.refreshInteractStatue = .Refreshing
                        updateTipsLabelText()
                        
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.scrollView!.contentInset = UIEdgeInsetsMake(self.scrollView!.contentInset.top, 0, CNRefreshProfile.kCNRefreshFootViewHeight, 0)
                            }, completion: { (isComplete) -> Void in
                                if isComplete {
                                    if self.style != .Button {
                                        self.action?()
                                    }
                                }
                        })
                    }
                    
                }

            }
        }
    }
}

// MARK: - 停止刷新
extension CNRefreshFootView {
    /**
     停止刷新
     */
    internal func endRefresh() {
        self.scrollView?.refreshStatue = .Normal
        self.scrollView?.refreshInteractStatue = .EndRefresh
        updateTipsLabelText()
        
        let time: NSTimeInterval = 2.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scrollView!.contentInset = UIEdgeInsetsMake(self.scrollView!.contentInset.top, 0, 0, 0)
                }) { (isComplete) -> Void in
                    self.activityView?.stopAnimating()
                    self.scrollView!.refreshInteractStatue = .Draging
                    self.updateTipsLabelText()
                    
                    if self.style == FootRefreshStyle.Button {
                        self.resetNormalStatue()
                    }
            }
        }
    }
    
    /**
     移除监听
     */
    internal func removeReFresh() {
        if self.superview != nil {
            scrollView!.removeObserver(self, forKeyPath: contentSizeKeyPath, context: &refreshFooterContext)
            scrollView!.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &refreshFooterContext)
            self.removeFromSuperview()
            action = nil
        }
    }
}
