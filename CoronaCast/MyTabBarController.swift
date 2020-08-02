//
//  MyTabBarController.swift
//  CoronaCast
//
//  Created by Tatsuya Moriguchi on 7/28/20.
//  Copyright © 2020 Tatsuya Moriguchi. All rights reserved.
//

// https://stackoverflow.com/questions/33837475/detect-when-a-tab-bar-item-is-pressed
// nice trick for future use

import UIKit

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller")
    }
    
}
