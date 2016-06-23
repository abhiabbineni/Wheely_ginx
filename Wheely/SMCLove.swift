//
//  SMCLove.swift
//  Wheely
//
//  Created by Abhiram Abbineni on 7/29/15.
//  Copyright (c) 2015 abhi. All rights reserved.
//

import Foundation

class SMClove {
    
    var value:Int = 0
    var minValue:Float = 0.0
    var maxValue: Float = 0.0
    var midValue: Float = 0.0

    
    func description() -> String {
        return "\(self.value) | \(self.minValue), \(self.midValue), \(self.maxValue)"
    }
}