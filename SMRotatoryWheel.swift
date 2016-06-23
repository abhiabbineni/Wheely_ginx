//
//  SMRotatoryWheel.swift
//  Wheely
//
//  Created by Abhiram Abbineni on 7/29/15.
//  Copyright (c) 2015 abhi. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics


var deltaAngle:Float?
var minAlphavalue:CGFloat = 0.6
var maxAlphavalue:CGFloat = 1.0

protocol SMRotaryProtocol1 {
    
    func wheelDidChangeValue(newValue: String)
    
}



class SMRotaryWheel:UIControl{

    


    var container:UIView?
    var cloves:[SMClove] = []
    var currentValue:Int = 0
    var numberOfSections: Double?
    var startTransform:CGAffineTransform!
    var delegate:SMRotaryProtocol!
    
//    @property (weak) id <SMRotaryProtocol> delegate;
//    @property (nonatomic, strong) UIView *container;
//    @property int numberOfSections;
//    @property CGAffineTransform startTransform;
//    @property (nonatomic, strong) NSMutableArray *cloves;
//    @property int currentValue;
    
    func initWithFrame(frame: CGRect, andDelegate del: AnyObject, withSections sectionsNumber: Double) -> AnyObject {
      
            
            self.currentValue = 0
            self.numberOfSections = sectionsNumber
           // self.delegate = del
            self.drawWheel()
            return self
    }
    
    func drawWheel() {
        container = UIView(frame: self.frame)
        var angleSize:CGFloat = CGFloat(2*(M_PI) / numberOfSections!)
        for var i = 0.0; i < numberOfSections; i++ {
            var im: UIImageView = UIImageView(image: UIImage(named:"segment.png"))
            im.layer.anchorPoint = CGPointMake(1.0, 0.5)
            im.layer.position = CGPointMake(container!.bounds.size.width / 2.0 - container!.frame.origin.x, container!.bounds.size.height / 2.0 - container!.frame.origin.y)
            var j = CGFloat(i)
            im.transform = CGAffineTransformMakeRotation(angleSize*j)//CGAffineTransformMakeRotation(angleSize * i)
            im.alpha = minAlphavalue
            im.tag = Int(i)
            if i == 0 {
                im.alpha = maxAlphavalue
            }
            var cloveImage: UIImageView = UIImageView(frame: CGRectMake(12, 15, 40, 40))
            cloveImage.image = UIImage(named:"icon\(i).png")
            im.addSubview(cloveImage)
            container!.addSubview(im)
        }
        container!.userInteractionEnabled = false
        self.addSubview(container!)
       // cloves = NSMutableArray.arrayWithCapacity(Int(numberOfSections))
        var bg: UIImageView = UIImageView(frame: self.frame)
        bg.image = UIImage(named:"bg.png")
        self.addSubview(bg)
        var mask: UIButton = UIButton(frame: CGRectMake(0, 0, 58, 58))
        mask.setImage(UIImage(named:"centerButton.png"), forState:UIControlState.Normal)
        mask.center = self.center
        mask.center = CGPointMake(mask.center.x, mask.center.y + 3)
        mask.addTarget(self, action: "spinWheel:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(mask)
        if numberOfSections! % 2 == 0 {
            self.buildClovesEven()
        }
        else {
            self.buildClovesOdd()
        }
       // self.delegate!.wheelDidChangeValue(self.getCloveName(currentValue))
    }
    
    func getCloveByValue(value: Int) -> UIImageView {
        var res: UIImageView?
        var views = container!.subviews
       
        for im in views {
            if im.tag == value {
                res = im as? UIImageView
            }
        }
        
        return res!
    }
    
    func buildClovesEven() {
        var fanWidth: Double = M_PI * 2 / numberOfSections!
        var mid: Float = 0
        for var i = 0.0; i < numberOfSections; i++ {
            var clove: SMClove = SMClove()
            clove.midValue = mid
            clove.minValue = mid - Float((fanWidth / 2))
            clove.maxValue = mid + Float((fanWidth / 2))
            clove.value = Int(i)
            if clove.maxValue - Float(fanWidth) < Float(-M_PI) {
                mid = Float(M_PI)
                clove.midValue = mid
                clove.minValue = fabsf(clove.maxValue)
            }
            mid -= Float(fanWidth)
            print("cl is \(clove)")
            cloves.append(clove)
        }
    }
    
    func buildClovesOdd() {
        var fanWidth: Double = M_PI * 2 / numberOfSections!
        var mid: Float = 0
        for var i = 0.0; i < numberOfSections; i++ {
            var clove: SMClove = SMClove()
            clove.midValue = mid
            clove.minValue = mid - Float((fanWidth / 2))
            clove.maxValue = mid + Float((fanWidth / 2))
            clove.value = Int(i)
            mid -= Float(fanWidth)
            if clove.minValue < Float(-M_PI) {
                mid = -mid
                mid -= Float(fanWidth)
            }
            cloves.append(clove)
            NSLog("cl is \(clove)")
        }
    }
    
    func calculateDistanceFromCenter(point: CGPoint) -> CGFloat {
        var center: CGPoint = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)
        var dx: CGFloat = point.x - center.x
        var dy: CGFloat = point.y - center.y
        return sqrt(dx * dx + dy * dy)
    }
    
    func getCloveName(position: Int) -> String {
        var res: String = ""
        switch position {
        case 0:
            res = "Circles"
            
        case 1:
            res = "Flower"
            
        case 2:
            res = "Monster"
            
        case 3:
            res = "Person"
            
        case 4:
            res = "Smile"
            
        case 5:
            res = "Sun"
            
        case 6:
            res = "Swirl"
            
        case 7:
            res = "3 circles"
            
        case 8:
            res = "Triangle"
            
        default:
            res = "Circles"

        }
        return res
    }
    
    func upDateContainer() {
        var radians: Float = atan2f(Float(container!.transform.b), Float(container!.transform.a))
        var newVal: Float = 0.0
        for c: SMClove in cloves {
            if c.minValue > 0 && c.maxValue < 0 {
                if c.maxValue > radians || c.minValue < radians {
                    if radians > 0 {
                        newVal = radians - Float(M_PI)
                    }
                    else {
                        newVal = Float(M_PI) + radians
                    }
                    currentValue = c.value
                }
            }
            else {
                if radians > c.minValue && radians < c.maxValue {
                    newVal = radians - c.midValue
                    currentValue = c.value
                }
            }
        }
    }
    
    func randomNumberBetween(min: Float, maxNumber max: Float) -> Float {
        return (min + Float((arc4random() / UINT32_MAX)) * ((max - min) + 1))
    }
    
    @IBAction func spinWheel(sender: AnyObject) {
       startTransform = container!.transform
        var im: UIImageView = self.getCloveByValue(currentValue)
        im.alpha = minAlphavalue
        self.spin()
    }
    
    func spin() {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.upDateContainer()
            
        })
        
        var rotation:CABasicAnimation!
        rotation.keyPath = "transform.rotation"
       // rotation = CABasicAnimation.animationWithKeyPath("transform.rotation")
        rotation.fromValue = NSNumber(float: 0.0)
       // rotation.fromValue = NSNumber.numberWithFloat(0)
        rotation.toValue = NSNumber(float:Float(2 * M_PI))
        rotation.duration = 1.0
        rotation.repeatCount = self.randomNumberBetween(3.0, maxNumber: 5.0)
        container!.transform = CGAffineTransformMakeRotation(CGFloat(self.randomNumberBetween(0, maxNumber: Float(2 * M_PI))))
        container!.layer.addAnimation(rotation, forKey: "Spin")
        
        CATransaction.commit()
    }
}