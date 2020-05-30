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
    var id: SystemSoundID
    var name: String
    
    static func getAllSounds() -> [Sound] {
        return [
            Sound(id: 1020, name: "Anticipate"),
            Sound(id: 1021, name: "Bloom"),
            Sound(id: 1022, name: "Calypso"),
            Sound(id: 1023, name: "Choo_Choo"),
            Sound(id: 1024, name: "Descent"),
            Sound(id: 1025, name: "Fanfare"),
            Sound(id: 1026, name: "Ladder"),
            Sound(id: 1027, name: "Minuet"),
            Sound(id: 1028, name: "News_Flash"),
            Sound(id: 1029, name: "Noir"),
            Sound(id: 1030, name: "Sherwood_Forest"),
            Sound(id: 1031, name: "Spell"),
            Sound(id: 1032, name: "Suspense"),
            Sound(id: 1033, name: "Telegraph"),
            Sound(id: 1034, name: "Tiptoes"),
            Sound(id: 1035, name: "Typewriters"),
            Sound(id: 1036, name: "Update")
        ]
    }
}
