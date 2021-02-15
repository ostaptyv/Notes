//
//  UIViewController+backViewController.swift
//  Notes
//
//  Created by Ostap Tyvonovych on 10.05.2019.
//  Copyright © 2019 OstapTyvonovych. All rights reserved.
//

import UIKit

extension UIViewController {
    ///Returns a UIViewController from the UINavigationController stack that goes after the current UIViewController
    func backViewController() -> UIViewController? {
        if let stack = self.navigationController?.viewControllers {
            for i in (1..<stack.count).reversed() {
                if(stack[i] == self && i >= 1) {
                    return stack[i-1]
                }
            }
        }
        return nil
    }
}
