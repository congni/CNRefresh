//
//  CNRefreshHeadView.swift
//  PortalHaojuSwift
//
//  Created by 葱泥 on 16/3/29.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

/// 顶部刷新View
class CNRefreshHeadView: UIView {
    /// 组件容器
    private var contentView: UIView!
    /// 文字组件
    private var tipsLabel: UILabel?
    /// 加载组件
    private var activityView: UIActivityIndicatorView?
    /// 图片组件
    private var loadingImageView: UIImageView?
    /// 转圈组件
    private var circleLoadingView: CNRefreshLoadingCircleView?
    /// observer context
    private var refreshHeaderContext = 1
    
    /// 类型模式
    internal var style: HeadRefreshStyle = .Activity
    /// 提示文本类型
    internal var tipLabelStyle: RefreshTipsLabelStyle = .Dynamic
    /// 存储回调
    internal var action: (() -> ())? = {}
    /// 设置scrollView
    internal weak var scrollView: UIScrollView! {
        didSet {
            updateTipsLabelText()
            
            scrollView.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .New, context: &refreshHeaderContext)
        }
    }
    
    /**
     初始化
     - parameter frame: frame
     - parameter style: 类型
     - returns: self
     */
    init(frame: CGRect, style: HeadRefreshStyle, tipLabelStyle: RefreshTipsLabelStyle) {
        self.style = style
        self.tipLabelStyle = tipLabelStyle
        super.init(frame: frame)
        
        self.backgroundColor = CNRefreshProfile.headViewBackgroundColor
        createUI()
    }
    
    /**
     根据类型，创建UI
     */
    private func createUI() {
        contentView = UIView()
        contentView.height = self.height
        contentView.width = self.width
        self.addSubview(contentView)
        
        if style == .Activity {
            activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityView?.bounds = CGRectMake(0, 0, 50, 50)
            contentView.addSubview(activityView!)
            activityView?.startAnimating()
            activityView?.left = contentView.width / 2.0 - activityView!.width - CNRefreshProfile.headTipsLabelOffset.vertical / 2.0
            activityView?.top = (contentView.height - activityView!.height) / 2.0
            
            if tipLabelStyle == .None {
                activityView?.left = (contentView.width  - activityView!.width) / 2.0
            }
        } else if style == .Image {
            loadingImageView = UIImageView(image: CNRefreshProfile.loadingImage)
            loadingImageView?.frame.size = loadingImageView!.image!.size
            contentView.addSubview(loadingImageView!)
            loadingImageView?.left = contentView.width / 2.0 - loadingImageView!.width - CNRefreshProfile.headTipsLabelOffset.vertical / 2.0
            loadingImageView?.top = (contentView.height - loadingImageView!.height) / 2.0
            
            if tipLabelStyle == .None {
                loadingImageView?.left = (contentView.width  - loadingImageView!.width) / 2.0
            }
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
                contentView.addSubview(loadingImageView!);
                loadingImageView?.frame.size = loadingAnimationImages[0].size
            } else {
                /// 如果发现序列图片数组是空的时候，则直接强转成图片类型
                loadingImageView = UIImageView(image: CNRefreshProfile.loadingImage)
                loadingImageView?.frame.size = loadingImageView!.image!.size
                contentView.addSubview(loadingImageView!)
                
                style = .Image
            }
            
            loadingImageView?.left = contentView.width / 2.0 - loadingImageView!.width - CNRefreshProfile.headTipsLabelOffset.vertical / 2.0
            loadingImageView?.top = (contentView.height - loadingImageView!.height) / 2.0
            
            if tipLabelStyle == .None {
                loadingImageView?.left = (contentView.width  - loadingImageView!.width) / 2.0
            }
        } else if style == .CircleLoading {
            circleLoadingView = CNRefreshLoadingCircleView(frame: CGRectMake(0, 0, 25.0, 25.0))
            circleLoadingView?.left = contentView.width / 2.0 - circleLoadingView!.width - CNRefreshProfile.headTipsLabelOffset.vertical / 2.0
            circleLoadingView?.top = (contentView.height - circleLoadingView!.height) / 2.0
            contentView.addSubview(circleLoadingView!)
            
            if tipLabelStyle == .None {
                circleLoadingView?.left = (contentView.width  - circleLoadingView!.width) / 2.0
            }
        }
        
        if tipLabelStyle != .None {
            tipsLabel = UILabel(textColor: CNRefreshProfile.headTipsLabelTextColor, textFontSize: CNRefreshProfile.headTipsLabelTextFontSize)
            contentView.addSubview(tipsLabel!)
            tipsLabel?.left = contentView.width / 2.0 + CNRefreshProfile.headTipsLabelOffset.vertical / 2.0
        }
    }
    
    /**
     监测，如果被调用到addSubView的时候，查找其父View
     - parameter newSuperview: newSuperview
     */
    override func willMoveToSuperview(newSuperview: UIView?) {
        if newSuperview != nil && ((newSuperview?.isKindOfClass(UIScrollView)) == true) {
            self.scrollView = newSuperview as! UIScrollView
        }
    }
    
    /**
     更新文字文案
     */
    private func updateTipsLabelText() {
        if tipLabelStyle != .None {
            if tipLabelStyle == .Dynamic {
                switch self.scrollView.refreshInteractStatue {
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
            } else if tipLabelStyle == .Static {
                tipsLabel?.text = CNRefreshProfile.tipLabelStaticText
                tipsLabel?.sizeToFit()
            }
            
            tipsLabel?.top = (contentView.height - tipsLabel!.height) / 2.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func pullCircleLoadingProgress() {
        let contentOffsetY: CGFloat = self.scrollView.contentOffset.y
        let startAnimationValue = contentView.height - circleLoadingView!.bottom
        let absContentOffsetY = abs(contentOffsetY)
        
        if absContentOffsetY > startAnimationValue  {
            let progress = (absContentOffsetY - startAnimationValue) / 50.0
            circleLoadingView?.pullProgress(progress)
        }
    }
}

// MARK: - UIScrollView 属性值监听回调
extension CNRefreshHeadView {
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print("keyPath  \(keyPath)")
        
        if self.superview == nil {
            scrollView.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &refreshHeaderContext)
        } else {
            refresh(contentOffsetKeyPath)
        }
    }
}

// MARK: - 外部调用
extension CNRefreshHeadView {
    /**
     刷新(头部刷新，一般只监听contentOffset变化)
     - parameter key: 相关key值的变化
     */
    internal func refresh(key: String) {
        let contentOffsetY: CGFloat = self.scrollView.contentOffset.y
        guard contentOffsetY < 0  else {
            return
        }
        
        guard self.scrollView!.refreshStatue != .Refreshing else {
            return
        }
        
        let scrollView = self.scrollView!
        let height = CNRefreshProfile.kCNRefreshHeadViewHeight
        
        if abs(contentOffsetY) > height && scrollView.dragging == false {
            if self.scrollView.refreshStatue != .Refreshing {
                self.scrollView.refreshStatue = .Refreshing
            }
            
            if self.scrollView.refreshInteractStatue != .Refreshing {
                self.scrollView.refreshInteractStatue = .Refreshing
                updateTipsLabelText()
            }
            
            if style == .CircleLoading {
                circleLoadingView?.startAnimation()
            }
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                scrollView.contentInset = UIEdgeInsetsMake(height, 0, scrollView.contentInset.bottom, 0)
                }, completion: { (isComplete) -> Void in
                    if isComplete {
                        self.action!()
                    }
            })
        } else if abs(contentOffsetY) > height && scrollView.dragging == true {
            if self.scrollView.refreshInteractStatue != .Release {
                self.scrollView.refreshInteractStatue = .Release
                updateTipsLabelText()
            }
            
            if style == .CircleLoading {
                pullCircleLoadingProgress()
            }
        } else if abs(contentOffsetY) < height {
            if self.scrollView.refreshInteractStatue != .Draging {
                self.scrollView.refreshInteractStatue = .Draging
                updateTipsLabelText()
            }
            
            if activityView?.isAnimating() == false {
                activityView?.startAnimating()
            }
            
            if loadingImageView?.isAnimating() == false {
                loadingImageView?.startAnimating()
            }
            
            if style == .CircleLoading {
                pullCircleLoadingProgress()
            }
        }
    }
}

// MARK: - 停止刷新
extension CNRefreshHeadView {
    /**
     停止刷新
     */
    internal func endRefresh() {
        self.scrollView.refreshStatue = .Normal
        self.scrollView.refreshInteractStatue = .EndRefresh
        updateTipsLabelText()
        
        let time: NSTimeInterval = 2.0
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.scrollView.contentInset.bottom, 0)
                }) { (isComplete) -> Void in
                    self.activityView?.stopAnimating()
                    self.loadingImageView?.stopAnimating();
                    self.scrollView.refreshInteractStatue = .Draging
                    self.updateTipsLabelText()
                    
                    if self.style == .CircleLoading {
                        self.circleLoadingView?.stopAnimation()
                    }
            }
        }
    }
    
    /**
     移除监听
     */
    internal func removeReFresh() {
        if self.superview != nil {
            scrollView.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &refreshHeaderContext)
            self.removeFromSuperview()
            self.action = nil
        }
    }
}
