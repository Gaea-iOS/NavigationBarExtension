//
//  UIImage+FromColor.swift
//  UINavigationBarStyle
//
//  Created by Alan on 17/4/6.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func from(_ color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        defer { UIGraphicsEndImageContext() }
        
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
