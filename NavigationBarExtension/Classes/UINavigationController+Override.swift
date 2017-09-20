
//
//  UINavigationController+Override.swift
//  Swifter
//
//  Created by 王小涛 on 2017/3/25.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    fileprivate static var didInitialize: Bool = false
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.addTarget(self, action: #selector(action))
    }
    
    open class func swizzle() {
        
        guard self == UINavigationController.self else { return }
        
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        guard !didInitialize else { return }
        didInitialize = true
        
        let selectors = [
            #selector(popToViewController(_: animated:)),
            #selector(popToRootViewController(animated:))
        ]
        
        selectors.forEach {
            let originalMethod = class_getInstanceMethod(self, $0)
            let swizzledSelector = Selector("swizzled_"+$0.description)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
    
    @objc fileprivate func action(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        // UIGestureRecognizerState 的状态转变参考 https://developer.apple.com/reference/appkit/nsgesturerecognizer
        
        guard let coor = topViewController?.transitionCoordinator else {return}
        guard let fromVC = coor.viewController(forKey: UITransitionContextViewControllerKey.from) else {return}
        guard let toVC = coor.viewController(forKey: UITransitionContextViewControllerKey.to) else {return}
        
        switch sender.state {
            
        case .changed:
            
            func average(_ from: CGFloat, to: CGFloat, percent: CGFloat) -> CGFloat {
                let result = from + (to - from) * percent
                return result
            }
            
            func averageColor(_ fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
                
                var fromRed: CGFloat = 0.0, fromGreen: CGFloat = 0.0, fromBlue: CGFloat = 0.0, fromAlpha: CGFloat = 0.0
                var toRed: CGFloat = 0.0, toGreen: CGFloat = 0.0, toBlue: CGFloat = 0.0, toAlpha: CGFloat = 0.0
                
                fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
                toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
                
                let froms = [fromRed, fromGreen, fromBlue, fromAlpha]
                let tos = [toRed, toGreen, toBlue, toAlpha]
                let nows = (0..<froms.count).map({
                    return average(froms[$0], to: tos[$0], percent: coor.percentComplete)
                })
                
                return UIColor(red: nows[0], green: nows[1], blue: nows[2], alpha: nows[3])
            }
            
            let fromAlpha = fromVC.navigationBarBackgroundAlpha
            let toAlpha = toVC.navigationBarBackgroundAlpha
            let nowAlpha = average(fromAlpha, to: toAlpha, percent: coor.percentComplete)
            navigationBar.setBackgroundAlpha(nowAlpha)
            
            let fromTintColor = fromVC.navigationBarTintColor ?? UIViewController.DefaultValue.navigationBarTintColor
            let toTintColor = toVC.navigationBarTintColor ?? UIViewController.DefaultValue.navigationBarTintColor
            let nowTintColor = averageColor(fromTintColor ?? .defaultNavigationBarTintColor, toColor: toTintColor ?? .defaultNavigationBarTintColor, percent: coor.percentComplete)
            navigationBar.tintColor = nowTintColor
            
        case .ended, .cancelled:
            
            let animations: (UITransitionContextViewControllerKey) -> () = {
                guard let viewController = coor.viewController(forKey: $0) else {return}
                self.navigationBar.update(with: viewController)
            }
            
            if coor.isCancelled {
                let duration = coor.transitionDuration * Double(coor.percentComplete)
                UIView.animate(withDuration: duration, animations: {
                    animations(UITransitionContextViewControllerKey.from)
                })
            }else {
                let duration = coor.transitionDuration * Double(1 - coor.percentComplete)
                UIView.animate(withDuration: duration, animations: {
                    animations(UITransitionContextViewControllerKey.to)
                })
            }
            
        default:
            break
        }
    }
    
    @objc fileprivate func swizzled_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        navigationBar.update(with: viewController)
        return swizzled_popToViewController(viewController, animated: animated)
    }
    
    @objc fileprivate func swizzled_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
        guard let viewController = viewControllers.first else {
            return swizzled_popToRootViewControllerAnimated(animated)
        }
        navigationBar.update(with: viewController)
        return swizzled_popToRootViewControllerAnimated(animated)
    }
}

extension UINavigationController: UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        if let coor = topViewController?.transitionCoordinator, coor.initiallyInteractive {
            return true
        }
        let itemCount = navigationBar.items?.count ?? 0
        let n = viewControllers.count >= itemCount ? 2 : 1
        let popToVC = viewControllers[viewControllers.count - n]
        navigationBar.update(with: popToVC)
        popToViewController(popToVC, animated: true)
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        guard let topVC = topViewController else {
            return true
        }
        navigationBar.update(with: topVC)
        return true
    }
}

extension UINavigationBar {
    
    fileprivate func update(with viewController : UIViewController) {
        setBackgroundAlpha(viewController.navigationBarBackgroundAlpha)
        tintColor = viewController.navigationBarTintColor
        titleTextAttributes = viewController.navigationBarTitleTextAttributes
        setBackgroundImage(viewController.navigationBarBackgroundImage, for: .default)
        viewController.setNeedsStatusBarAppearanceUpdate()
        hideShadowImage(viewController.navigationBarShadowImageHidden)
    }
}


extension UIColor {
    
    fileprivate class var defaultNavigationBarTintColor: UIColor {
        return UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1.0)
    }
}


