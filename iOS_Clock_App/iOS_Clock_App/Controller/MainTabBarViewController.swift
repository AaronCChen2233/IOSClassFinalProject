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
        
        let firstViewController = ViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        let AlarmTVC = AlarmTableViewController(style: .grouped)
        AlarmTVC.container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        let secondViewController = UINavigationController(rootViewController: AlarmTVC)
        secondViewController.tabBarItem = UITabBarItem(title: "alarm", image: UIImage(named: "alarm_white"), tag: 1)

        let tabBarList = [firstViewController, secondViewController]
        UITabBar.appearance().tintColor = UIColor(named: "highlightOrange")
        viewControllers = tabBarList
    }
}
