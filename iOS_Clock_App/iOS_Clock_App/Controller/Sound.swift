//
//  Sound.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-30.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import Foundation
import AudioToolbox

struct Sound {
    var id: Int
    var name: String
    
    static func getAllSounds() -> [Sound] {
        return [
            Sound(id: 1, name: "bell"),
            Sound(id: 2, name: "tickle"),
            Sound(id: 3, name: "analog"),
            Sound(id: 4, name: "bomb"),
            Sound(id: 5, name: "house_fire_alarm"),
            Sound(id: 6, name: "buzz"),
            Sound(id: 7, name: "school_bell"),
            Sound(id: 8, name: "cop_car"),
            Sound(id: 9, name: "rooster"),
            Sound(id: 10, name: "siren"),
        ]
    }
}
