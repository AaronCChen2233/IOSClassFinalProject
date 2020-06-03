//
//  Week.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-29.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import Foundation

struct Week {
    var type: weekType
    
    enum weekType: Int {
        case mon = 0
        case tue = 1
        case wed = 2
        case thu = 3
        case fri = 4
        case sat = 5
        case sun = 6
    }
    
    static func getAllWeek() -> [Week] {
        return [
            Week(type: .mon),
            Week(type: .tue),
            Week(type: .wed),
            Week(type: .thu),
            Week(type: .fri),
            Week(type: .sat),
            Week(type: .sun),
        ].sorted(by: {$0.type < $1.type})
    }
}


extension Week.weekType: Comparable {
    static func <(lhs: Week.weekType, rhs: Week.weekType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension Week.weekType: RawRepresentable {
    typealias description = String

    init?(description: String) {
      switch description {
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

    var description: String {
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


