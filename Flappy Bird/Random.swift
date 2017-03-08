//
//  Random.swift
//  Flappy Bird
//
//  Created by Caroline Davis on 8/03/2017.
//  Copyright © 2017 Caroline Davis. All rights reserved.
//

import Foundation
import CoreGraphics


public extension CGFloat {
    
    // anything we type here will be available in cgfloat 
    
    public static func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        
        // gives the random number
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + firstNum
        
    }
    
}












