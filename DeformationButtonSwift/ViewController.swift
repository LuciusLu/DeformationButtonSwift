//
//  ViewController.swift
//  DeformationButtonSwift
//
//  Created by 陆浩志 on 15/7/14.
//  Copyright (c) 2015年 Moz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func getColor(hexColor:String)->UIColor{
        var redInt:uint = 0
        var greenInt:uint = 0
        var blueInt:uint = 0
        var range = NSMakeRange(0, 2)
        
        NSScanner(string: (hexColor as NSString).substringWithRange(range)).scanHexInt(&redInt)
        range.location = 2
        NSScanner(string: (hexColor as NSString).substringWithRange(range)).scanHexInt(&greenInt)
        range.location = 4
        NSScanner(string: (hexColor as NSString).substringWithRange(range)).scanHexInt(&blueInt)

        return UIColor(red: (CGFloat(redInt)/255.0), green: (CGFloat(greenInt)/255.0), blue: (CGFloat(blueInt)/255.0), alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let deformationBtn = DeformationButton(frame: CGRectMake(100, 100, 140, 36), color: getColor("e13536"))
        self.view.addSubview(deformationBtn)
        
        deformationBtn.forDisplayButton.setTitle("微博注册", forState: UIControlState.Normal)
        deformationBtn.forDisplayButton.titleLabel?.font = UIFont.systemFontOfSize(15);
        deformationBtn.forDisplayButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        deformationBtn.forDisplayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
        deformationBtn.forDisplayButton.setImage(UIImage(named:"微博logo.png"), forState: UIControlState.Normal)

        deformationBtn.addTarget(self, action: "btnEvent", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func btnEvent(){
        print("btnEvent")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

