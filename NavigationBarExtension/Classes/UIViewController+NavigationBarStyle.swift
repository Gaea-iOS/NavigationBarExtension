//
//  UIViewController+NavigationBarStyle.swift
//  Swifter
//
//  Created by 王小涛 on 2017/3/25.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public struct DefaultValue {
        public static var navigationBarBackgroundAlpha: CGFloat = 1.0
        public static var navigationBarTintColor: UIColor? = nil
        public static var navigationBarTitleTextAttributes: [NSAttributedStringKey : Any]? = nil
        public static var navigationBarBackgroundImage: UIImage? = nil
        public static var navigationBarShadowImageHidden: Bool = false
    }
    
    fileprivate struct NavigationBarAssociatedKeys {
        static var navigationBarBackgroundAlpha = "navigationBarBackgroundAlpha"
        static var navigationBarTintColor = "navigationBarTintColor"
        static var navigationBarTitleTextAttributes = "navigationBarTitleTextAttributes"
        static var navigationBarBackgroundImage = "navigationBarBackgroundImage"
        static var navigationBarShadowImageHidden = "navigationBarShadowImageHidden"
    }
    
    public var navigationBarBackgroundAlpha: CGFloat {
        get {
            guard let alpha = objc_getAssociatedObject(self, &NavigationBarAssociatedKeys.navigationBarBackgroundAlpha) as? CGFloat else {
                return DefaultValue.navigationBarBackgroundAlpha
            }
            return alpha
        }
        set {
            navigationController?.navigationBar.setBackgroundAlpha(newValue)
            objc_setAssociatedObject(self, &NavigationBarAssociatedKeys.navigationBarBackgroundAlpha, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var navigationBarTintColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &NavigationBarAssociatedKeys.navigationBarTintColor) as? UIColor {
                return color
            } else {
                return DefaultValue.navigationBarTintColor
            }
        }
        set {
            navigationController?.navigationBar.tintColor = newValue
            objc_setAssociatedObject(self, &NavigationBarAssociatedKeys.navigationBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var navigationBarTitleTextAttributes: [NSAttributedStringKey : Any]? {
        get {
            if let attributes = objc_getAssociatedObject(self, &NavigationBarAssociatedKeys.navigationBarTitleTextAttributes) as? [NSAttributedStringKey : Any] {
                return attributes
            }else {
                return DefaultValue.navigationBarTitleTextAttributes
            }
        }
        set {
            navigationController?.navigationBar.titleTextAttributes = newValue
            objc_setAssociatedObject(self, &NavigationBarAssociatedKeys.navigationBarTitleTextAttributes, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var navigationBarBackgroundImage: UIImage? {
        get  {
            if let image = objc_getAssociatedObject(self, &NavigationBarAssociatedKeys.navigationBarBackgroundImage) as? UIImage {
                return image
            }else {
                return DefaultValue.navigationBarBackgroundImage
            }
        }
        set {
            navigationController?.navigationBar.setBackgroundImage(newValue, for: .default)
            objc_setAssociatedObject(self, &NavigationBarAssociatedKeys.navigationBarBackgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var navigationBarShadowImageHidden: Bool {
        get  {
            if let hidden = objc_getAssociatedObject(self, &NavigationBarAssociatedKeys.navigationBarShadowImageHidden) as? Bool {
                return hidden
            }else {
                return DefaultValue.navigationBarShadowImageHidden
            }
        }
        set {
            navigationController?.navigationBar.hideShadowImage(newValue)
            objc_setAssociatedObject(self, &NavigationBarAssociatedKeys.navigationBarShadowImageHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


