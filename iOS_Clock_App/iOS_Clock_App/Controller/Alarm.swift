//
//  Alarm.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-28.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import Foundation

struct Alarm {
    var date: Date
    var week: Set<Week.weekType>
    var label: String
    var sound: String
    var isOn: Bool = true
    
    static func initialize() -> [Alarm] {
        return [
            Alarm(date: Date(), week: [.thu, .mon, .wed], label: "Mon and Tue", sound: "hard something"),
            Alarm(date: Date(), week: [.sat, .sun], label: "Weenends", sound: "happy something"),
            Alarm(date: Date(), week: [.fri], label: "TGIF", sound: "exciting something", isOn: false),
            Alarm(date: Date(), week: [], label: "TGIF", sound: "exciting something", isOn: false)
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

        if self.week.count == 2 && self.week.contains(.sat) && self.week.contains(.sun) { return "Every Weekend" }
        if self.week.count == 5 && self.week.filter({$0 != .sat && $0 != .sun }).count == 5 { return "Every Weekday"}
        return self.week.sorted(by: {$0 < $1}).reduce("", { $0 + $1.description[..<$1.description.index($1.description.startIndex, offsetBy: 3)] + " "})
    }
}

