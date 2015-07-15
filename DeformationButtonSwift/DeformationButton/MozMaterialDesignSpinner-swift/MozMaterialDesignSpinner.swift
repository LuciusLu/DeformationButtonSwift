//
//  MozMaterialDesignSpinner.swift
//  DeformationButtonSwift
//
//  Created by 陆浩志 on 15/7/14.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

import UIKit

class MozMaterialDesignSpinner: UIView {

    let kAnimationStrokeKey:String! = "animationStrokeKey"
    let kAnimationRotationKey:String! = "animationRotationKey"
    
    var _progressLayer:CAShapeLayer!
    var progressLayer:CAShapeLayer {
        get{
            if (_progressLayer == nil){
                _progressLayer = CAShapeLayer()
                _progressLayer.strokeColor = self.tintColor.CGColor
                _progressLayer.fillColor = nil
                _progressLayer.lineWidth = 2
//                _progressLayer.shouldRasterize = true
            }
            return _progressLayer
        }
        set{ self._progressLayer = newValue }
    }
    
    var isAnimating:Bool = false
    var _hidesWhenStopped:Bool = true
    let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    var lineWidth:CGFloat{
        get{ return self.progressLayer.lineWidth }
        set{ self.progressLayer.lineWidth = newValue
             updatePath() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.layer.addSublayer(self.progressLayer)
  
        self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
        updatePath()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetAnimations", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.progressLayer.strokeColor = self.tintColor.CGColor
    }
    
    func resetAnimations() {
        if self.isAnimating {
            stopAnimating()
            startAnimating()
        }
    }
    
    func setAnimating(animate:Bool) {
        animate ? startAnimating() : stopAnimating()
    }
    
    func startAnimating() {
        if self.isAnimating {
            return
        }

        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = 4.0
        animation.fromValue = 0
        animation.toValue = 2*M_PI
        animation.repeatCount = Float(NSIntegerMax)
        self.progressLayer.addAnimation(animation, forKey: kAnimationRotationKey)
        
        let headAnimation = CABasicAnimation()
        headAnimation.keyPath = "strokeStart";
        headAnimation.duration = 1.0
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = self.timingFunction
        
        let tailAnimation = CABasicAnimation()
        tailAnimation.keyPath = "strokeEnd"
        tailAnimation.duration = 1.0
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1.0
        tailAnimation.timingFunction = self.timingFunction
        
        let endHeadAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = "strokeStart"
        endHeadAnimation.beginTime = 1.0
        endHeadAnimation.duration = 0.5
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = self.timingFunction
        
        let endTailAnimation = CABasicAnimation()
        endTailAnimation.keyPath = "strokeEnd"
        endTailAnimation.beginTime = 1.0
        endTailAnimation.duration = 0.5
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = self.timingFunction
        
        let animations = CAAnimationGroup()
        animations.duration = 1.5
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = Float(NSIntegerMax)
        self.progressLayer.addAnimation(animations, forKey: kAnimationStrokeKey)
        
        self.isAnimating = true
        
        if _hidesWhenStopped {
            self.hidden = false
        }
    }
    
    func stopAnimating() {
        if !self.isAnimating {
            return
        }
        
        self.progressLayer.removeAnimationForKey(kAnimationRotationKey)
        self.progressLayer.removeAnimationForKey(kAnimationStrokeKey)
        self.isAnimating = false
        
        if _hidesWhenStopped {
            self.hidden = true
        }
        
    }
    
//MARK: - Private
    
    func updatePath() {
        let acenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        let aradius = min(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds) / 2) - self.progressLayer.lineWidth / 2
        let astartAngle = CGFloat(0)
        let aendAngle = CGFloat(2*M_PI)
        let path:UIBezierPath = UIBezierPath(arcCenter: center, radius: aradius, startAngle: astartAngle, endAngle: aendAngle, clockwise: true)

        self.progressLayer.path = path.CGPath
        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = 0.0
    }
    
//MARK: - Properties
    
//    func lineWidth() -> CGFloat{
//        return self.progressLayer.lineWidth
//    }
//    
//    func setLineWidth(lineWidth:CGFloat){
//        self.progressLayer.lineWidth = lineWidth
//        updatePath()
//    }
    
    func setHidesWhenStopped(hidesWhenStopped:Bool){
        _hidesWhenStopped = hidesWhenStopped
        self.hidden = !self.isAnimating && hidesWhenStopped
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
