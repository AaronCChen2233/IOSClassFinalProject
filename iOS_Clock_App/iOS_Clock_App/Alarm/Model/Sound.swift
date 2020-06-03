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
    var name: SoundName
    
    enum SoundName: String {
        case bell = "bell"
        case tickle = "tickle"
        case analog = "analog"
        case bomb = "bomb"
        case house_fire_alarm = "house_fire_alarm"
        case buzz = "buzz"
        case school_bell = "school_bell"
        case cop_car = "cop_car"
        case rooster = "rooster"
        case siren = "siren"
    }
    
    static func getAllSounds() -> [Sound] {
        return [
            Sound(name: .bell),
            Sound(name: .tickle),
            Sound(name: .analog),
            Sound(name: .bomb),
            Sound(name: .house_fire_alarm),
            Sound(name: .buzz),
            Sound(name: .school_bell),
            Sound(name: .cop_car),
            Sound(name: .rooster),
            Sound(name: .siren),
        ]
    }
}
