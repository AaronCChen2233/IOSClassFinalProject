//
//  CityElement.swift
//  iOS_Clock_App
//
//  Created by WendaLi on 2020-06-01.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let city= try? newJSONDecoder().decode(Cities.self, from: jsonData)

import Foundation

// MARK: - TimeZone
struct TimeZone: Codable {
    let status, message: String
    let zones: [Zone]
}

// MARK: - Zone
struct Zone: Codable {
    var countryCode, countryName, zoneName: String
    var gmtOffset, timestamp: Int
    
    init() {
        countryCode = ""
        countryName = ""
        zoneName = ""
        gmtOffset = 0
        timestamp = 0
    }
}

extension Zone: Hashable {
  static func == (lhs: Zone, rhs: Zone) -> Bool {
    return lhs.zoneName == rhs.zoneName
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(zoneName)
  }
}
