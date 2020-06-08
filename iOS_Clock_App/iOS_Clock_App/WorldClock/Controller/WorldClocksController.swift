//
//  WelcomeElementController.swift
//  iOS_Clock_App
//
//  Created by WendaLi on 2020-06-01.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import Foundation

class WorldClocksController {
    init() {}
    
    var worldClocks = WorldClockList()
//    {
//        didSet{
//            NotificationCenter.default.post(name: WorldClocksController.worldClocksUpdatedNotification, object: nil)
//        }
//    }
    var zones = [Zone]() {
        didSet{
            NotificationCenter.default.post(name: WorldClocksController.zonesUpdatedNotification, object: nil)
        }
    }
    static let shared = WorldClocksController()
//    static let worldClocksUpdatedNotification = Notification.Name("WorldClocksController.worldClocksUpdated")
    static let zonesUpdatedNotification = Notification.Name("WorldClocksController.zonesUpdated")
}
