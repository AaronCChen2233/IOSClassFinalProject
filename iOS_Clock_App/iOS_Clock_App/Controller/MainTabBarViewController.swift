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
<<<<<<< HEAD
//        view.backgroundColor = .white
        let firstViewController = StopwatchViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)

=======
        
        let firstViewController = ViewController()        
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
>>>>>>> master
        let secondViewController = ViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        let tabBarList = [firstViewController, secondViewController]
        UITabBar.appearance().tintColor = UIColor(named: "highlightOrange")
        viewControllers = tabBarList
<<<<<<< HEAD
        
        UITabBar.appearance().tintColor = colorThem.highlightOrange
        print(traitCollection.userInterfaceStyle.rawValue)
        
=======
>>>>>>> master
    }

    
}
