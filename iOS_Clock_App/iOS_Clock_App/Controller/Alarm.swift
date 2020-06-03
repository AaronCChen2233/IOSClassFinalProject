//
//  Alarm.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-28.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import Foundation

struct Alarm {
    var id: Int
    var date: Date
    var week: Set<Week.weekType.RawValue>
    var label: String = "Label"
    var sound: Sound = Sound.getAllSounds().first!
    var isOn: Bool = true
    var notificationIds: [String] = []
    
    static func initialize() -> [Alarm] {
        return [
            Alarm(id: 0, date: Date(), week: [0,1], label: "Mon and Tue"),
            Alarm(id: 1, date: Date(), week: [5,6], label: "Weenends"),
            Alarm(id: 2, date: Date(), week: [4], label: "TGIF", isOn: false),
            Alarm(id: 3, date: Date(), week: [], label: "Nothing", isOn: false)
        ]
    }
    
    func dateformat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self.date)
    }
    
    func getWeekDescription() -> String? {
        guard self.week.count != 0 else { return nil }
        guard self.week.count != 1 else { return "Every \(self.week.first!.description)" }
        guard self.week.count < 7 else { return "Everyday"}

        if self.week.count == 2 && self.week.contains(5) && self.week.contains(6) { return "Every Weekend" }
        if self.week.count == 5 && self.week.filter({$0 != 5 && $0 != 6 }).count == 5 { return "Every Weekday"}
        return self.week.sorted(by: {$0 < $1}).reduce("", { x, y in
            let week: String = Week.weekType(rawValue: y)!.description
            return x! + week[..<week.index(week.startIndex, offsetBy: 3)] + " "
        })
    }
}

