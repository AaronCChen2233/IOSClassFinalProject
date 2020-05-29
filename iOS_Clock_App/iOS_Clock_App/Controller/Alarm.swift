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
    var repeatWeekdays: Set<weekDays>
    var label: String
    var sound: String
    var isOn: Bool = true
    
    enum weekDays {
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat
        case sun
    }
    
    static func initialize() -> [Alarm] {
        return [
            Alarm(date: Date().addingTimeInterval(TimeInterval(86400*Int(arc4random_uniform(1)))), repeatWeekdays: [.mon, .thu], label: "Mon and Tue", sound: "hard something"),
            Alarm(date: Date().addingTimeInterval(TimeInterval(86400*Int(arc4random_uniform(1)))), repeatWeekdays: [.sat, .sun], label: "Weenends", sound: "happy something"),
            Alarm(date: Date().addingTimeInterval(TimeInterval(86400*Int(arc4random_uniform(1)))), repeatWeekdays: [.fri], label: "TGIF", sound: "exciting something", isOn: false)
        ]
    }
    
    func dateformat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self.date)
    }
    
    func description() -> String {
        guard self.repeatWeekdays.count != 0 else { return "" }
        guard self.repeatWeekdays.count != 1 else { return "Every \(self.repeatWeekdays.first!.rawValue)" }
        guard self.repeatWeekdays.count < 7 else { return "Everyday"}

        if self.repeatWeekdays.count == 2 && self.repeatWeekdays.contains(.sat) && self.repeatWeekdays.contains(.sun) { return "Every Weekend" }
        if self.repeatWeekdays.filter({$0 != .sat && $0 != .sun }).count == 5 { return "Every Weekday"}
        return self.repeatWeekdays.reduce("", { $0 + $1.rawValue[..<$1.rawValue.index($1.rawValue.startIndex, offsetBy: 3)] + " "})
    }
}

extension Alarm.weekDays: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: String) {
      switch rawValue {
        case "Monday": self = .mon
        case "Tuesday": self = .tue
        case "Wednesday": self = .wed
        case "Thursday": self = .thu
        case "Friday": self = .fri
        case "Saturday": self = .sat
        case "Sunday": self = .sun
        default:
          return nil
      }
    }
    
    var rawValue: String {
      switch self {
        case .mon: return "Monday"
        case .tue: return "Tuesday"
        case .wed: return "Wednesday"
        case .thu: return "Thursday"
        case .fri: return "Friday"
        case .sat: return "Saturday"
        case .sun: return "Sunday"
      }
    }
}

