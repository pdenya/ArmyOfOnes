//
//  UIView+FrameShorthand.swift
//  ArmyOfOnes
//
//  Created by Paul Denya on 10/25/16.
//  Copyright © 2016 Paul Denya. All rights reserved.
//

import UIKit

extension UIView {
    func bottomEdge() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    func setHeight(_ height:CGFloat) -> Void {
        var frame:CGRect = self.frame;
        frame.size.height = height;
        self.frame = frame;
    }
    
    func setY(_ y:CGFloat) -> Void {
        var frame:CGRect = self.frame;
        frame.origin.y = y;
        self.frame = frame;
    }
}
