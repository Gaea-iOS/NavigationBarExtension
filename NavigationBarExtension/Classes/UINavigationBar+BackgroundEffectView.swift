//
//  UINavigationBar+BackgroundEffectView.swift
//  Swifter
//
//  Created by 王小涛 on 2017/3/25.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    fileprivate var backgroundEffectView: UIView? {
        
        if #available(iOS 10.0, *) {
            return backgroundView?.value(forKey: "_backgroundEffectView") as? UIView
        } else {
            return backgroundView?.value(forKeyPath: "_adaptiveBackdrop._backdropEffectView") as? UIView
        }
    }
    
    fileprivate var shadowView: UIView? {
        return backgroundView?.value(forKey: "_shadowView") as? UIView
    }
    
    fileprivate var backgroundView: UIView? {
        return subviews.first
    }
    
    public func setBackgroundAlpha(_ alpha: CGFloat) {
        
        shadowView?.alpha = alpha
        
        if isTranslucent {
            backgroundEffectView?.alpha = alpha
        }
        
        backgroundView?.alpha = alpha
    }
    
    public func hideShadowImage(_ hidden: Bool) {
        shadowView?.isHidden = hidden
    }
}


