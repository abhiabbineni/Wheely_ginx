//
//  ViewController.swift
//  Wheely
//
//  Created by Abhiram Abbineni on 7/29/15.
//  Copyright (c) 2015 abhi. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var  valueLabel = UILabel(frame: CGRectMake(100, 350, 120, 30))
    var createwheel = UIButton(frame: CGRectMake(100, 400, 120, 30))
    override func viewDidLoad() {
        super.viewDidLoad()

           
            valueLabel.backgroundColor = UIColor.lightGrayColor()
            createwheel.setTitle("Custom Wheel", forState: UIControlState.Normal)
            createwheel.backgroundColor = UIColor.lightGrayColor()
            self.view.addSubview(valueLabel)
            self.view.addSubview(createwheel)
        
        var wheel = SMRotaryWheel()
        wheel.initWithFrame(CGRectMake(0, 0, 220, 220), andDelegate:self, withSections: 8)
        self.view.addSubview(wheel)
        
        
        func wheelDidChangeValue(newValue: String) {
            self.valueLabel.text = newValue
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

