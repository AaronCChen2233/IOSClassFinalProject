//
//  MainTabBarViewController.swift
//  iOS_Clock_App
//
//  Created by Aaron Chen on 2020-05-27.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**Just For test now*/
        view.backgroundColor = .white
        let firstViewController = ViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let secondViewController = ViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        let tabBarList = [firstViewController, secondViewController]
        viewControllers = tabBarList
        
    }

    
}