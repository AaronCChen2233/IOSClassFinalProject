//
//  WorldClocks.swift
//  iOS_Clock_App
//
//  Created by WendaLi on 2020-06-01.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import Foundation

struct WorldClockList: Codable {
    var worldClockList: [Zone]

    init(worldClockList: [Zone] = []) {
        self.worldClockList = worldClockList
    }
}
