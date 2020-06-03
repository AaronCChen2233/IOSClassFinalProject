//
//  ManagedTimeZone.swift
//  iOS_Clock_App
//
//  Created by WendaLi on 2020-06-03.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit
import CoreData

class ManagedTimeZone: NSManagedObject {
    class func readAllTimeZone(in context: NSManagedObjectContext, completion: @escaping ([Zone]?) -> Void) {
        let request: NSFetchRequest<ManagedTimeZone> = ManagedTimeZone.fetchRequest()
        do {
            let matches = try context.fetch(request)
            var zones = [Zone]()
            for matche in matches {
                var zone = Zone()
                zone.countryCode = matche.countryCode ?? ""
                zone.countryName = matche.countryName ?? ""
                zone.gmtOffset = Int(matche.gmtOffset)
                zone.timestamp = Int(matche.timestamp)
                zone.zoneName = matche.zoneName ?? ""
                zones.append(zone)
            }
            completion(zones)
        } catch {
        }
    }
    
    class func findOrCreateTimeZone(matching timeZoneInfo: Zone, with zoneName: String, in context: NSManagedObjectContext) throws -> ManagedTimeZone {
        let request: NSFetchRequest<ManagedTimeZone> = ManagedTimeZone.fetchRequest()
        request.predicate = NSPredicate(format: "zoneName = %@", timeZoneInfo.zoneName)
        // NSSortDescriptor possible
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "ManagedTimeZone.findOrCreateTimeZone -- database inconsistency")
                let matchedTimeZone = matches[0]
                let zoneName = timeZoneInfo.zoneName.split(separator: "/")
                let cityName = zoneName[1]
                matchedTimeZone.city = String(cityName)
                matchedTimeZone.countryCode = timeZoneInfo.countryCode
                matchedTimeZone.countryName = timeZoneInfo.countryName
                matchedTimeZone.gmtOffset = Int64(timeZoneInfo.gmtOffset)
                matchedTimeZone.timestamp = Int64(timeZoneInfo.timestamp)
                matchedTimeZone.zoneName = timeZoneInfo.zoneName
                return matchedTimeZone
            }
        } catch {
            throw error
        }
      
        // no match
        let timeZone = ManagedTimeZone(context: context)
        let zoneName = timeZoneInfo.zoneName.split(separator: "/")
        let cityName = zoneName[1]
        timeZone.city = String(cityName)
        timeZone.countryCode = timeZoneInfo.countryCode
        timeZone.countryName = timeZoneInfo.countryName
        timeZone.gmtOffset = Int64(timeZoneInfo.gmtOffset)
        timeZone.timestamp = Int64(timeZoneInfo.timestamp)
        timeZone.zoneName = timeZoneInfo.zoneName
        return timeZone
    }
}

extension ManagedTimeZone {
    func converToZone() -> Zone {
        var zone = Zone()
        zone.countryCode = self.countryCode ?? ""
        zone.countryName = self.countryName ?? ""
        zone.gmtOffset = Int(self.gmtOffset)
        zone.timestamp = Int(self.timestamp)
        zone.zoneName = self.zoneName ?? ""
        return zone
    }
}
