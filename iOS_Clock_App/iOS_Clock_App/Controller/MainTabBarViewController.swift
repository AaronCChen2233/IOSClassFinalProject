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
        
        let firstViewController = TimerViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        let secondViewController = StopwatchViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)

        let AlarmTVC = AlarmTableViewController(style: .grouped)
        AlarmTVC.container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        let thirdViewController = UINavigationController(rootViewController: AlarmTVC)
        thirdViewController.tabBarItem = UITabBarItem(title: "alarm", image: UIImage(named: "alarm_white"), tag: 2)

        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        UITabBar.appearance().tintColor = UIColor(named: "highlightOrange")
        viewControllers = tabBarList

    }
}
