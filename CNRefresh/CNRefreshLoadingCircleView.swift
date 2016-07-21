//
//  CNRefreshLoadingCircleView.swift
//  PortalHaojuSwift
//
//  abstract  转圈loading
//
//  Created by haoju-congni on 16/5/11.
//  Copyright © 2016年 好居. All rights reserved.
//

import UIKit

// MARK: - CGFloat转换
public extension CGFloat {
    public func toRadians() -> CGFloat {
        return (self * CGFloat(M_PI)) / 180.0
    }
    
    public func toDegrees() -> CGFloat {
        return self * 180.0 / CGFloat(M_PI)
    }
}

/// 转圈loading
class CNRefreshLoadingCircleView: UIView {
    /// 旋转Key
    private let kRotationAnimation = "kRotationAnimation"
    /// CAShapeLayer
    lazy private var circleShapeLayer = CAShapeLayer()
    
    /**
     初始化
     - parameter frame: frame
     - returns: self
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     配置CAShapeLayer
     */
    private func configure() {
        circleShapeLayer.frame = self.bounds
        circleShapeLayer.lineWidth = 1.0
        circleShapeLayer.fillColor = UIColor.clearColor().CGColor
        circleShapeLayer.strokeColor = CNRefreshProfile.circleLoadingStrokeColor
        self.layer.addSublayer(circleShapeLayer)
        
        /// 贝塞尔曲线
        let circlePath = UIBezierPath(ovalInRect: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height))
        circleShapeLayer.path = circlePath.CGPath
        
        /// 画笔设置
        circleShapeLayer.strokeStart = 0.0
        circleShapeLayer.strokeEnd = 0.0
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    /**
     获取角度值
     - returns: CGFloat
     */
    private func currentDegree() -> CGFloat {
        return circleShapeLayer.valueForKeyPath("transform.rotation.z") as! CGFloat
    }
}

// MARK: - 对外接口
extension CNRefreshLoadingCircleView {
    /**
     设置strokeEnd值，这个是根据scrollView的拖拽程度来设定的
     - parameter progress: progress
     */
    func pullProgress(progress: CGFloat) {
        circleShapeLayer.strokeEnd = min(0.9 * progress, 0.9)
        let transform = CATransform3DIdentity
        circleShapeLayer.transform = CATransform3DRotate(transform, CGFloat(-70.0).toRadians(), 0.0, 0.0, 1.0)
    }
    
    /**
     旋转
     */
    func startAnimation() {
        guard circleShapeLayer.animationForKey(kRotationAnimation) == nil else {
            return
        }
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat(2 * M_PI) + currentDegree()
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = Float.infinity
        rotationAnimation.removedOnCompletion = false
        rotationAnimation.fillMode = kCAFillModeForwards
        circleShapeLayer.addAnimation(rotationAnimation, forKey: kRotationAnimation)
    }
    
    /**
     停止旋转
     */
    func stopAnimation() {
        circleShapeLayer.removeAnimationForKey(kRotationAnimation)
    }
}
