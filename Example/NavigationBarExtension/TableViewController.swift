//
//  TableViewController.swift
//  UINavigationBarStyle
//
//  Created by Alan on 17/4/6.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import NavigationBarExtension


class TableViewController: UITableViewController {
    
    var index = 1


    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        navigationBarBackgroundAlpha = 0
        navigationBarTintColor = UIColor.red
        statusBarStyle = .lightContent
        navigationBarTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        statusBarStyle = .lightContent
        
        navigationBarShadowImageHidden = true
        title = String(describing: index)
        index = index + 1
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = min(max(scrollView.contentOffset.y / 80, 0), 1)
        navigationBarBackgroundAlpha = alpha
        if alpha > 0.9 {
            navigationBarTintColor = nil
            statusBarStyle = .default
            navigationBarTitleTextAttributes = nil
        } else {
            navigationBarTintColor = UIColor.red
            statusBarStyle = .lightContent
            navigationBarTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        
    }
    
    @IBAction func clickBarButtonItem(_ sender: AnyObject) {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TableViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func clickPopToButton(_ sender: AnyObject) {
        
        let controller = navigationController!.viewControllers[navigationController!.viewControllers.count - 3]
        navigationController?.popToViewController(controller, animated: true)
    }
    
    @IBAction func clickPopRootButton(_ sender: AnyObject) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return statusBarStyle
//    }
}
