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
    var repeatWeekdays: [weekDays]
    var label: String
    var sound: String
    
    enum weekDays {
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat
        case sun
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

