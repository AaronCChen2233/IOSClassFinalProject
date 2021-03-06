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
        
        /**World Clock*/
        let worldClockRVC = WorldClockViewController()
        worldClockRVC.container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        let worldClockViewController = UINavigationController(rootViewController: worldClockRVC)
        worldClockViewController.tabBarItem = UITabBarItem(title: "World Clock", image: UIImage(systemName: "globe"), tag: 0)
        //worldClockViewController.tabBarItem = UITabBarItem(title: "World Clock", image: UIImage(named: "globe"), selectedImage: UIImage(named: ""))
        
        /**Alarm*/
        let AlarmTVC = AlarmTableViewController(style: .grouped)
        AlarmTVC.container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        let alarmViewController = UINavigationController(rootViewController: AlarmTVC)
//        alarmViewController.tabBarItem = UITabBarItem(title: "alarm", image: UIImage(named: "alarm_white"), tag: 1)
        alarmViewController.tabBarItem = UITabBarItem(title: "alarm", image: UIImage(systemName: "alarm"), tag: 1)
        
        /**Stop watch*/
        let stopwatchViewController = StopwatchViewController()
        stopwatchViewController.tabBarItem = UITabBarItem(title: "Stopwatch", image: UIImage(systemName: "stopwatch"), tag: 2)

        /**Timer*/
        let timerViewController = TimerViewController()
        timerViewController.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(systemName: "timer"), tag: 3)

        let tabBarList = [worldClockViewController, alarmViewController, stopwatchViewController, timerViewController]
//        let tabBarList = [timerViewController ,worldClockViewController, alarmViewController, stopwatchViewController]
        UITabBar.appearance().tintColor = UIColor(named: "highlightOrange")
        viewControllers = tabBarList
    }
}
