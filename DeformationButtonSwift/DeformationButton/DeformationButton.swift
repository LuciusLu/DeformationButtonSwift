//
//  DeformationButton.swift
//  DeformationButtonSwift
//
//  Created by 陆浩志 on 15/7/14.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

import UIKit
//@property(nonatomic, assign)BOOL isLoading;
//@property(nonatomic, retain)MMMaterialDesignSpinner *spinnerView;
//@property(nonatomic, retain)UIColor *contentColor;
//@property(nonatomic, retain)UIColor *progressColor;
//
//@property(nonatomic, retain)UIButton *forDisplayButton;
class DeformationButton: UIControl {

    var defaultW:CGFloat!
    var defaultH:CGFloat!
    var defaultR:CGFloat!
    var scale:CGFloat!
    var bgView:UIView!
    
    var spinnerView:MozMaterialDesignSpinner!
    var forDisplayButton:UIButton!
    
    var btnBackgroundImage:UIImage?
    
    var _isLoading:Bool = false
    var isLoading:Bool{
        get{ return _isLoading }
        set{
            _isLoading = newValue
            if _isLoading {
                self.startLoading()
            }else{
                self.stopLoading()
            }
        }
    }
    
    var _contentColor:UIColor!
    var contentColor:UIColor {
        get{
            return _contentColor
        }
        set{
            _contentColor = newValue
        }
    }
    
    var _progressColor:UIColor!
    var progressColor:UIColor {
        get{
            return _progressColor
        }
        set{
            _progressColor = newValue
        }
    }
    
    override var frame: CGRect {
        get {
            let _frame = super.frame

            return _frame
        }
        set {
            super.frame = newValue
        }
    }
    
    override var selected: Bool{
        get{return super.selected}
        set{
            super.selected = newValue
            self.forDisplayButton.selected = newValue
        }
    }
    
    override var highlighted: Bool{
        get{return super.highlighted}
        set{
            super.highlighted = newValue
            self.forDisplayButton.highlighted = newValue
        }
    }
    
    init(frame: CGRect, color:UIColor) {
        super.init(frame: frame)
        initSettingWithColor(color)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettingWithColor(self.tintColor)
    }
    
    func imageWithColor(color:UIColor, cornerRadius:CGFloat) -> UIImage{
        let rect = CGRectMake(0, 0, cornerRadius*2+10, cornerRadius*2+10)
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.lineWidth = 0
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        path.fill()
        path.stroke()
        path.addClip()
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    func initSettingWithColor(color:UIColor) {
        self.scale = 1.2
        self.bgView = UIView(frame: self.bounds)
        self.bgView.backgroundColor = color
        self.bgView.userInteractionEnabled = false
        self.bgView.hidden = true
        self.bgView.layer.cornerRadius = CGFloat(3)
        self.addSubview(self.bgView)
        
        defaultW = self.bgView.frame.width
        defaultH = self.bgView.frame.height
        defaultR = self.bgView.layer.cornerRadius
        
        self.spinnerView = MozMaterialDesignSpinner(frame: CGRectMake(0 , 0, defaultH*0.8, defaultH*0.8))
        self.spinnerView.tintColor = UIColor.whiteColor()
        self.spinnerView.lineWidth = 2
        self.spinnerView.center = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds))
        self.spinnerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.spinnerView.userInteractionEnabled = false

        self.addSubview(self.spinnerView)
        
        self.addTarget(self, action: "loadingAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.forDisplayButton = UIButton(frame: self.bounds)
        self.forDisplayButton.userInteractionEnabled = false
        
        let image = imageWithColor(color, cornerRadius: 3)
        self.forDisplayButton.setBackgroundImage(image.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 10, 10, 10)), forState: UIControlState.Normal)
    
        self.addSubview(self.forDisplayButton)
        self.contentColor = color;
    }

    func loadingAction() {
        if (self.isLoading) {
            self.stopLoading()
        }else{
            self.startLoading()
        }
    }
    
    func startLoading(){
        if (btnBackgroundImage == nil) {
            btnBackgroundImage = self.forDisplayButton.backgroundImageForState(UIControlState.Normal)
        }
        
        _isLoading = true;
        self.bgView.hidden = false
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = defaultR
        animation.toValue = defaultH*scale*0.5
        animation.duration = 0.3
        self.bgView.layer.cornerRadius = defaultH*scale*0.5
        self.bgView.layer.addAnimation(animation, forKey: "cornerRadius")
        
        self.forDisplayButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.bgView.layer.bounds = CGRectMake(0, 0, self.defaultW*self.scale, self.defaultH*self.scale)
        }) { (Bool) -> Void in
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.bgView.layer.bounds = CGRectMake(0, 0, self.defaultH*self.scale, self.defaultH*self.scale)
                self.forDisplayButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.forDisplayButton.alpha = 0
                }) { (Bool) -> Void in
                    self.forDisplayButton.hidden = true
                    self.spinnerView.startAnimating()
            }
        }
    }
    
    func stopLoading(){
        self.spinnerView.stopAnimating()
        self.forDisplayButton.hidden = false
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.forDisplayButton.transform = CGAffineTransformMakeScale(1, 1);
            self.forDisplayButton.alpha = 1;
            }) { (Bool) -> Void in
        }
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = defaultH*scale*0.5
        animation.toValue = defaultR
        animation.duration = 0.3
        self.bgView.layer.cornerRadius = defaultR
        self.bgView.layer.addAnimation(animation, forKey: "cornerRadius")
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.bgView.layer.bounds = CGRectMake(0, 0, self.defaultW*self.scale, self.defaultH*self.scale);
            }) { (Bool) -> Void in
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                animation.fromValue = self.bgView.layer.cornerRadius
                animation.toValue = self.defaultR
                animation.duration = 0.2
                self.bgView.layer.cornerRadius = self.defaultR
                self.bgView.layer.addAnimation(animation, forKey: "cornerRadius")
                
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.bgView.layer.bounds = CGRectMake(0, 0, self.defaultW, self.defaultH);
                    }) { (Bool) -> Void in
                        if (self.btnBackgroundImage != nil) {
                            self.forDisplayButton.setBackgroundImage(self.btnBackgroundImage, forState: UIControlState.Normal)
                        }
                        self.bgView.hidden = true
                        self._isLoading = false
                }
        }
    }
    

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
