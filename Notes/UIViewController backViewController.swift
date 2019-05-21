//
//  UIViewController backViewController.swift
//  Notes
//
//  Created by user149331 on 5/10/19.
//  Copyright © 2019 Ostap. All rights reserved.
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
