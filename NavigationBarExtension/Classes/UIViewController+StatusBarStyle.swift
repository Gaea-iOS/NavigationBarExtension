//
//  UIViewController+StatusBarStyle.swift
//  Swifter
//
//  Created by 王小涛 on 2017/3/28.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

//  info.plist文件中，View controller-based status bar appearance项设为YES，则View controller对status bar的设置优先级高于application的设置。为NO则以application的设置为准，view controller的prefersStatusBarHidden方法无效，是根本不会被调用的。
// http://blog.csdn.net/gaoyp/article/details/18406501

extension UINavigationController {
    
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        let style = topViewController?.statusBarStyle ?? .default
        return style
    }
}

extension UIViewController {
    
    fileprivate struct StatusBarAssociatedKeys {
        static var preferredStatusBarStyle = "preferredStatusBarStyle"
    }
    
    public var statusBarStyle: UIStatusBarStyle {
        get {
            let raw = objc_getAssociatedObject(self, &StatusBarAssociatedKeys.preferredStatusBarStyle)
            guard let rawValue = raw as? Int else {
                return .default
            }
            return UIStatusBarStyle(rawValue: rawValue) ?? .default
        }
        set {
            setNeedsStatusBarAppearanceUpdate()
            objc_setAssociatedObject(self, &StatusBarAssociatedKeys.preferredStatusBarStyle, newValue.rawValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
